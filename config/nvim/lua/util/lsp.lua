local M = {}

function M.on_attach(_, bufnum)
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnum, desc = desc })
  end

  nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  nmap("<leader>ck", vim.lsp.buf.signature_help, "Code Signature")
  nmap("<leader>cs", require("telescope.builtin").lsp_document_symbols, "Code Symbols")
  nmap("<leader>cw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

  nmap("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
  nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
  nmap("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")

  nmap("K", vim.lsp.buf.hover, "Hover Documentation") -- See `:help K` for why this keymap
end

return M
