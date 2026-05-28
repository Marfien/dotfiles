local M = {}

local function project_dir()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients > 0 and clients[1].config.root_dir then
    return vim.fn.fnamemodify(clients[1].config.root_dir, ":t")
  end
  local git_dir = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel 2>/dev/null")
  if vim.v.shell_error == 0 then
    return vim.fn.fnamemodify(vim.trim(git_dir), ":t")
  end
  return "󱉭 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

local function filename()
  return require("util.paths").pretty_path(project_dir())
end

local function git_branch()
  return " " .. require("util.git").get_branch()
end

local function fileformat()
  local sym_map = {
    dos = "CR",
    unix = "LF",
    mac = "CRLF"
  }

  return sym_map[vim.bo.fileformat]
end

local function fileencoding()
  local result = vim.opt.fileencoding:get()

  if vim.opt.bomb:get() then
    result = result .. ' [BOM]'
  end

  return result
end

local function cursor_position()
  local mode = vim.fn.mode()
  if mode == "V" or mode == "v" or mode == "\22" then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    return start_line .. ".." .. end_line
  end
  local loc = vim.api.nvim_win_get_cursor(0)
  return loc[1] .. ":" .. loc[2]
end

M.key = {
  project_dir = "project_dir",
  filename = "filename",
  git_branch = "git_branch",
  fileformat = "fileformat",
  fileencoding = "fileencoding",
  cursor_position = "cursor_position"
}

function M.setup_autocmds(group)
  local update = require("features.status-line.draw-cache").update
  local function create(event, key, func)
    vim.api.nvim_create_autocmd(event, {
      group = group,
      callback = function()
        update(key, func())
      end
    })
    update(key, func())
  end

  create("DirChanged", M.key.project_dir, project_dir)
  create({ "BufEnter", "FileType" }, M.key.filename, filename)
  create("BufEnter", M.key.git_branch, git_branch)
  create("BufEnter", M.key.fileformat, fileformat)
  create("BufEnter", M.key.fileencoding, fileencoding)
  create({ "CursorMoved", "CursorMovedI" }, M.key.cursor_position, cursor_position)
end

return M
