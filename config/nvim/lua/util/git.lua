local M = {}

local link_ref = "file"

local remote_patterns = {
  { "^(https?://.*)%.git$", "%1" },
  { "^git@(.+):(.+)%.git$", "https://%1/%2" },
  { "^git@(.+):(.+)$", "https://%1/%2" },
  { "^git@(.+)/(.+)$", "https://%1/%2" },
  { "^org%-%d+@(.+):(.+)%.git$", "https://%1/%2" },
  { "^ssh://git@(.*)$", "https://%1" },
  { "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
  { "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
  { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
  { "^https://%w*@(.*)", "https://%1" },
  { "^git@(.*)", "https://%1" },
  { ":%d+", "" },
  { "%.git$", "" },
}

local url_patterns = {
  ["github%.com"] = {
    branch = "/tree/{branch}",
    file = "/blob/{branch}/{file}#L{line}",
    permalink = "/blob/{commit}/{file}#L{line}",
    commit = "/commit/{commit}",
  },
  ["gitlab%.com"] = {
    branch = "/-/tree/{branch}",
    file = "/-/blob/{branch}/{file}#L{line}",
    permalink = "/-/blob/{commit}/{file}#L{line}",
    commit = "/-/commit/{commit}",
  },
  ["bitbucket%.org"] = {
    branch = "/src/{branch}",
    file = "/src/{branch}/{file}#lines-{line}",
    permalink = "/src/{commit}/{file}#lines-{line}",
    commit = "/commits/{commit}",
  },
  ["git.sr.ht"] = {
    branch = "/tree/{branch}",
    file = "/tree/{branch}/item/{file}",
    permalink = "/tree/{commit}/item/{file}#L{line}",
    commit = "/commit/{commit}",
  },
}
url_patterns[""] = url_patterns["gitlab%.com"]

function M.get_remotes(cwd)
  local proc = vim.fn.system({ "git", "-C", cwd, "remote", "-v" })
  local unparsed_remotes = vim.split(vim.trim(proc), "\n")
  local remotes = {}
  for _, line in ipairs(unparsed_remotes) do
    local name, remote_url = line:match("(%S+)%s+(%S+)%s+%(fetch%)")

    if name and remote_url then
      table.insert(remotes, {
        name = name,
        url = remote_url,
      })
    end
  end

  return remotes
end

function M.get_branch(cwd)
  local proc = vim.fn.system({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" })
  return vim.split(vim.trim(proc), "\n")[1]
end

function M.get_file_path(file, cwd)
  local proc = vim.fn.system({ "git", "-C", cwd, "ls-files", "--full-name", file })
  return vim.split(vim.trim(proc), "\n")[1]
end

function M.get_last_commit(file, cwd)
  local proc = vim.fn.system({ "git", "-C", cwd, "log", "-n", "1", "--pretty=format:%H", "--", file })
  return vim.split(vim.trim(proc), "\n")[1]
end

function M.get_repo(remote)
  local ret = remote
  for _, pattern in ipairs(remote_patterns) do
    ret = ret:gsub(pattern[1], pattern[2]) --[[@as string]]
  end
  return ret:find("https://") == 1 and ret or ("https://%s"):format(ret)
end

function M.get_url(repo, fields)
  for remote, patterns in pairs(url_patterns) do
    if repo:find(remote) then
      local pattern = patterns[link_ref]
      return repo
        .. pattern:gsub("(%b{})", function(key)
          local val = fields[key:sub(2, -2)] or key
          print("Replace " .. key .. " with " .. val)
          return val
        end)
    end
  end
  return repo
end

function M.get_default_branch()
  local res = vim.system({ "git", "rev-parse", "--verify", "main" }, { capture_output = true }):wait()
  return res.code == 0 and "main" or "master"
end

---@class util.OpenOpts
---@field file? string
---@field cwd? string
---@field line? integer

---@param opts util.OpenOpts
function M.open(opts)
  opts = opts or {}
  local file = opts.file or vim.api.nvim_buf_get_name(0) ---@type string?
  file = file and (vim.uv.fs_stat(file) or {}).type == "file" and vim.fs.normalize(file) or nil
  local cwd = opts.cwd or (file and vim.fn.fnamemodify(file, ":h") or vim.fn.getcwd())

  local fields = {
    branch = M.get_branch(cwd),
    commit = M.get_last_commit(file, cwd),
    file = M.get_file_path(file, cwd),
    line = opts.line or vim.fn.line("."),
  }

  print(fields.branch .. " " .. fields.commit .. " " .. fields.file)

  local function open(remote)
    local repo = M.get_repo(remote.url)
    local url = M.get_url(repo, fields)

    vim.notify(("Opening [%s](%s)"):format(remote.name, remote.url))
    vim.ui.open(url)
  end

  local remotes = M.get_remotes(cwd)

  if #remotes == 0 then
    vim.notify("No remotes found", vim.log.levels.WARN)
    return
  elseif #remotes == 1 then
    open(remotes[1])
    return
  end

  vim.ui.select(remotes, {
    prompt = "Select remote",
    format_item = function(item)
      return item.name .. (" "):rep(8 - #item.name) .. " (" .. item.url .. ")"
    end,
  }, open)
end

return M
