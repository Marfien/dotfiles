vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("q_quit", {}),
  pattern = "help,term,neotest-output-panel,vim,touble",
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf, desc = "Close bufer" })
  end,
})

-- delete empty buffers when new one is added
vim.api.nvim_create_autocmd("BufAdd", {
  group = vim.api.nvim_create_augroup("empty_buf_delete", {}),
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].filetype == "Empty" then
        require("util.buffers").delete({ buf = buf })
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
  group = vim.api.nvim_create_augroup("local_quickview", {}),
  callback = function(event)
    local buf = event.buf
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local local_dir = vim.fn.expand("~/.local/")

    if buf_name:sub(1, #local_dir) == local_dir then
      vim.schedule(function()
        require("util.buffers").delete({ buf = buf })
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ft_wrap", {}),
  pattern = { "markdown", "latex", "ascidoc" },
  callback = function()
    vim.wo.wrap = true
  end,
})
