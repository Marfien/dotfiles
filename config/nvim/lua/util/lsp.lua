local M = {}

function on_attach(bufnum, client_id)
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnum, desc = desc })
  end

  -- code mapings
  nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  nmap("<leader>ck", vim.lsp.buf.signature_help, "Code Signature")
  nmap("<leader>cs", require("telescope.builtin").lsp_document_symbols, "Code Symbols")
  nmap("<leader>cw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

  -- find mappings
  nmap("<leader>fi", require("telescope.builtin").lsp_implementations, "Find Implementation")
  nmap("<leader>fr", require("telescope.builtin").lsp_references, "Find References")

  -- goto mappings
  nmap("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")

  pcall(vim.keymap.del, "n", "K", { buffer = bufnum })
  nmap("K", vim.lsp.buf.hover, "Hover Documentation") -- See `:help K` for why this keymap
end

function M.autocmd()
  return {
    group = vim.api.nvim_create_augroup("lap_attach", {}),
    pattern = "*",
    callback = function(event)
      on_attach(event.buf, event.data.client_id)
    end,
  }
end

return M
