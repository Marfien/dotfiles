local devicons = require("nvim-web-devicons")

local M = {}

local root_cache = {}

function M.project_root()
  if vim.lsp.client.root_dir then
    return vim.lsp.client.root_dir
  end

  local filepath = vim.api.nvim_buf_get_name(0)
  if root_cache[filepath] then
    return root_cache[filepath]
  end

  local start_dir = filepath ~= "" and vim.fn.fnamemodify(filepath, ":p:h") or vim.fn.getcwd()
  local git_dir = vim.fs.find(".git", { upward = true, path = start_dir })[1]

  local root = vim.fn.getcwd()

  if git_dir then
    return vim.fn.fnamemodify(git_dir, ":h")
  end

  root_cache[filepath] = root
  return root
end

function M.pretty_path(relative)
  local path = vim.fn.expand("%:p")

  if path == "" then
    return ""
  end

  -- :// is often used for meta bufs
  if not vim.bo.buflisted or path:find("://") then
    return ""
  end

  local parts

  if path:sub(1, #relative) == relative then
    local rel_path = path:sub(#relative + 2)
    parts = vim.split(rel_path, "/")

    if #parts > 3 then
      parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
    end
    -- Not within root
  else
    parts = vim.split(path, "/")

    if #parts > 4 then
      parts = { parts[1], "…", parts[#parts - 2], parts[#parts - 1], parts[#parts] }
    end
  end

  local dir_string = table.concat(parts, "/")

  if dir_string == "" or dir_string == "." then
    return " "
  end

  if vim.bo.readonly == 1 then
    dir_string = dir_string .. " 󰌾 "
  end

  local icon = devicons.get_icon(parts[#parts]) or devicons.get_icon_by_filetype(vim.bo.filetype)
  if icon then
    dir_string = icon .. " " .. dir_string
  end

  return dir_string
end

return M
