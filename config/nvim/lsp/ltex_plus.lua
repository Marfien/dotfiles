vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("ltex-keymap", {}),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or client.name ~= "ltex_plus" then
      return
    end

    vim.keymap.set("n", "]s", function()
      local diag = vim.diagnostic.get_next({ severity = "INFO" })
      if diag ~= nil then
        vim.diagnostic.jump({ diagnostic = diag })
      else
        return "]s"
      end
    end, { buffer = event.buf, expr = true, noremap = true })

    vim.keymap.set("n", "[s", function()
      local diag = vim.diagnostic.get_prev({ severity = "INFO" })
      if diag ~= nil then
        vim.diagnostic.jump({ diagnostic = diag })
      else
        return "[s"
      end
    end, { buffer = event.buf, expr = true, noremap = true })
  end,
})

local language_id_mapping = {
  bib = "bibtex",
  pandoc = "markdown",
  plaintex = "tex",
  rnoweb = "rsweave",
  rst = "restructuredtext",
  tex = "latex",
  text = "plaintext",
}

---@type vim.lsp.Config
return {
  cmd = { "ltex-ls-plus" },
  filetypes = {
    "bib",
    "context",
    "gitcommit",
    "html",
    "markdown",
    "org",
    "pandoc",
    "plaintex",
    "quarto",
    "mail",
    "mdx",
    "rmd",
    "rnoweb",
    "rst",
    "tex",
    "text",
    "typst",
    "xhtml",
  },
  root_markers = { ".git" },
  get_language_id = function(_, filetype)
    return language_id_mapping[filetype] or filetype
  end,
  settings = {
    ltex = {
      language = "auto",
      enabled = {
        "bib",
        "context",
        "gitcommit",
        "html",
        "markdown",
        "org",
        "pandoc",
        "plaintex",
        "quarto",
        "mail",
        "mdx",
        "rmd",
        "rnoweb",
        "rst",
        "tex",
        "latex",
        "text",
        "typst",
        "xhtml",
      },
    },
  },
}
