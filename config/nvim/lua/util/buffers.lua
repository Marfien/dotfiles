local M = {}

local function safe_switch_buf(buf_to_delete)
  for _, win in ipairs(vim.fn.win_findbuf(buf_to_delete)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf_to_delete then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf_to_delete and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd.bprevious)
      if has_previous and buf_to_delete ~= vim.api.nvim_win_get_buf(win) then
        return
      end
    end)
  end
end

function M.delete(opts)
  opts = opts or {}
  opts.buf = opts.buf or 0

  if opts.filter then
    for _, buf in ipairs(vim.tbl_filter(opts.filter, vim.api.nvim_list_bufs())) do
      if vim.bo[buf].buflisted then
        M.delete({ buf = buf })
      end
    end
  else
    safe_switch_buf(opts.buf)
    if vim.api.nvim_buf_is_valid(opts.buf) then
      vim.api.nvim_buf_delete(opts.buf, { force = true })
    end
  end
end

function M.others(buf)
  return buf ~= vim.api.nvim_get_current_buf()
end

function M.all(_)
  return true
end

return M
