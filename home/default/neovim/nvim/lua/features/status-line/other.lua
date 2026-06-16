local M = {}

local function project_dir()
  local proj_root = require("features.status-line.util").project_root()
  return "󱉭 " .. vim.fn.fnamemodify(proj_root, ":t")
end

local function git_branch()
  local branch = require("util.git").get_branch()
  return branch and (" " .. branch) or ""
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
  local result = string.upper(vim.opt.fileencoding:get())

  if vim.opt.bomb:get() then
    result = result .. ' [BOM]'
  end

  return result
end

local function cursor_position()
  local _, line, col, _ = unpack(vim.fn.getpos("."))

  local additional_switch = {
    V = function()
      local start_line = vim.fn.line("v")
      return math.abs(line - start_line) + 1
    end,
    v = function()
      local _, from_line, from_col, _ = unpack(vim.fn.getpos("v"))
      local reverse = from_line > line or (from_line == line and from_col > col)

      local content = vim.fn.join(vim.api.nvim_buf_get_text(0,
        (reverse and line or from_line) - 1,
        (reverse and col or from_col) - 1,
        (reverse and from_line or line) - 1,
        reverse and from_col or col,
        {}
      ), "")

      return #content
    end,
    ["\22"] = function()
      local _, from_line, from_col, _ = unpack(vim.fn.getpos("v"))

      return (math.abs(line - from_line) + 1) .. "," .. (math.abs(col - from_col) + 1)
    end
  }
  local generator = additional_switch[vim.fn.mode()]
  local additional = generator and (" (" .. generator() .. ")") or ""

  return line .. ":" .. col .. additional
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

  create({ "DirChanged", "BufEnter" }, M.key.project_dir, project_dir)
  create("BufEnter", M.key.git_branch, git_branch)
  create("BufEnter", M.key.fileformat, fileformat)
  create("BufEnter", M.key.fileencoding, fileencoding)
  create({ "CursorMoved", "CursorMovedI", "ModeChanged" }, M.key.cursor_position, cursor_position)
end

return M
