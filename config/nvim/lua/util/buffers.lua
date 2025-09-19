local M = {}

local function safe_switch_buf(buf_to_delete)
  for _, win in ipairs(vim.fn.win_findbuf(buf_to_delete)) do
    vim.api.nvim_win_call(win, function()
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf_to_delete ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
end

function M.delete(opts)
  opts = opts or {}

  if opts.filter then
    for _, buf in ipairs(vim.tbl_filter(opts.filter, vim.api.nvim_list_bufs())) do
      if vim.bo[buf].buflisted then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  else
    safe_switch_buf(opts.buf)
    vim.api.nvim_buf_delete(opts.buf or 0, { force = true })
  end
end

function M.others(buf)
  return buf ~= vim.api.nvim_get_current_buf()
end

function M.all(_)
  return true
end

return M
