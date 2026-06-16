vim.schedule(function()
  vim.filetype.add({
    pattern = {
      [".*%.gitlab%-ci%.ya?ml"] = "yaml.gitlab",
    },
  })
end)

return require("util.lsp").ensure_lang({
  ft = { "yaml" },
  formatters = { "prettier" },
  other = {
    {
      "b0o/SchemaStore.nvim",
      lazy = true,
      version = false, -- last release is way too old
    },
  },
})
