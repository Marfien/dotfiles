vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "help,term",
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf, desc = "Close bufer" })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    -- check if treesitter has parser
    if require("nvim-treesitter.parsers").has_parser() then
      -- use treesitter folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    else
      -- use alternative foldmethod
      vim.opt.foldmethod = "indent"
    end
  end,
})

-- delete empty buffers when new one is added
vim.api.nvim_create_autocmd("BufAdd", {
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].filetype == "Empty" then
        require("util.buffers").delete({ buf = buf })
      end
    end
  end,
})
