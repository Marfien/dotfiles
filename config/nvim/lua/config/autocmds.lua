vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("q_quit", {}),
  pattern = "help,term,neotest-output-panel,vim,touble,qf",
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

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ft_wrap", {}),
  pattern = { "markdown", "latex", "ascidoc" },
  callback = function()
    vim.wo.wrap = true
  end,
})

vim.api.nvim_create_autocmd("WinNew", {
  group = vim.api.nvim_create_augroup("editor_winboarder", {}),
  callback = function()
    local config = vim.api.nvim_win_get_config(0)
    -- Disable border for full screen windows
    if config.relative == "editor" and config.width == vim.o.columns and config.height == vim.o.lines then
      vim.api.nvim_win_set_config(0, { border = "none" })
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_word_highlight", {}),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client ~= nil and client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", {})

      vim.opt.updatetime = 2000

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = group,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        buffer = event.buf,
        group = group,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf,trouble",
  group = vim.api.nvim_create_augroup("unlist_bufs", {}),
  callback = function()
    vim.bo.buflisted = false
  end,
})
