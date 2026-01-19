vim.filetype.add({
  pattern = {
    [".*%.gitlab%-ci%.ya?ml"] = "yaml.gitlab",
  },
})

return require("util.lsp").ensure_lang({
  parsers = { "yaml" },
  ft = { "yaml", "yml" },
  tools = { "yaml-language-server", "gitlab-ci-ls" },
  formatters = { "prettier" },
  other = {
    {
      "b0o/SchemaStore.nvim",
      lazy = true,
      version = false, -- last release is way too old
    },
  },
})
