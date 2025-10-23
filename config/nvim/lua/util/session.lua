local M = {}

local cache_path = vim.fn.stdpath("data") .. "/sessions"

vim.fn.mkdir(cache_path, "p")

local function calc_path(callback)
  vim.system(
    { "md5" },
    { stdin = vim.fn.getcwd() },
    vim.schedule_wrap(function(data)
      if data.code ~= 0 then
        vim.notify("Error hashing cwd: " .. data.stderr)
        return
      end
      local hash = vim.fn.trim(data.stdout)
      callback(hash)
    end)
  )
end

local function _store(id)
  vim.cmd.mksession({ cache_path .. "/" .. id })
  vim.notify("Stored session with id: " .. id)
end

function M.store(id)
  if id == nil then
    calc_path(_store)
  else
    _store(id)
  end
end

local function _load(id)
  local session_file = cache_path .. "/" .. id
  if vim.fn.filereadable(session_file) ~= 0 then
    vim.cmd.source({ session_file })
    vim.notify("Restored session with id: " .. id)
  else
    vim.notify("Could not find session with id: " .. id, vim.log.levels.ERROR)
  end
end

function M.load(id)
  if id == nil then
    calc_path(_load)
  else
    _load(id)
  end
end

return M
