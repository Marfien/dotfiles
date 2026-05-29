local M = {}

local function project_dir()
  local proj_root = require("features.status-line.util").project_root()
  return "󱉭 " .. vim.fn.fnamemodify(proj_root, ":t")
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
    return math.min(start_line, end_line) .. ".." .. math.max(start_line, end_line)
  end
  local loc = vim.api.nvim_win_get_cursor(0)
  return loc[1] .. ":" .. loc[2]
end

M.key = {
  project_dir = "project_dir",
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
  create("BufEnter", M.key.git_branch, git_branch)
  create("BufEnter", M.key.fileformat, fileformat)
  create("BufEnter", M.key.fileencoding, fileencoding)
  create({ "CursorMoved", "CursorMovedI", "ModeChanged" }, M.key.cursor_position, cursor_position)
end

return M
