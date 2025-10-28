local M = {}

function M.others(buf)
  return buf ~= vim.api.nvim_get_current_buf()
end

function M.all(_)
  return true
end

return M
