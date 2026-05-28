local M = {}

M.key = "buf_count"

local function update()
  local cached_count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted then
      cached_count = cached_count + 1
    end
  end
  require("features.status-line.draw-cache").update(M.key, cached_count)
end

function M.setup_autocmds(group)
  vim.api.nvim_create_autocmd({ "BufNew", "BufAdd", "BufDelete", "VimEnter" }, {
    group = group,
    callback = vim.schedule_wrap(update),
  })

  update()
end

return M
