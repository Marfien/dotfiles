local M = {}

function M.project_root()
  -- TODO: lsp project root

  local filepath = vim.api.nvim_buf_get_name(0)
  local start_dir = filepath ~= "" and vim.fn.fnamemodify(filepath, ":p:h") or vim.fn.getcwd()
  local git_dir = vim.fs.find(".git", { upward = true, path = start_dir })[1]
  if git_dir then
    return vim.fn.fnamemodify(git_dir, ":h")
  end
  return vim.fn.getcwd()
end

function M.pretty_path(relative)
  local path = vim.fn.expand("%:p")

  if path == "" then
    return ""
  end

  local rel_path = path:sub(#relative + 2)
  local parts = vim.split(rel_path, "/")

  if #parts > 3 then
    parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
  end

  dir_string = table.concat(parts, "/")

  if vim.bo.readonly == 1 then
    dir_string = dir_string .. " 󰌾 "
  end

  return dir_string
end

return M
