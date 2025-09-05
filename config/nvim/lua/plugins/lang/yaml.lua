return require("util.lsp").ensure_lang({
  parsers = { "yaml" },
  ft = { "yaml", "yml" },
  lsp = "yaml-language-server",
  other = {
    {
      "b0o/SchemaStore.nvim",
      lazy = true,
      version = false, -- last release is way too old
    },
  },
})
