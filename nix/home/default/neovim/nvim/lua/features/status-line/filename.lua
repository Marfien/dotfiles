local M = {}

M.key = "filename"

local function pretty_path(relative)
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

  local devicons = require("nvim-web-devicons")
  local icon = devicons.get_icon(parts[#parts]) or devicons.get_icon_by_filetype(vim.bo.filetype)
  if icon then
    dir_string = icon .. " " .. dir_string
  end

  return dir_string
end

local function update()
  local proj_root = require("features.status-line.util").project_root()

  local color = ""
  local bufname = vim.api.nvim_buf_get_name(0)
  if vim.fn.filereadable(bufname) == 0 then
    color = "%#DiagnosticInfo#"
  elseif vim.bo.modified then
    color = "%#DiagnosticWarn#"
  end

  local path = pretty_path(proj_root)
  require("features.status-line.draw-cache").update(M.key, (path and path ~= "") and (color .. path) or "")
end

function M.setup_autocmds(group)
  vim.api.nvim_create_autocmd({ "BufEnter", "BufModifiedSet" }, {
    group = group,
    callback = update
  })
  update()
end

return M
