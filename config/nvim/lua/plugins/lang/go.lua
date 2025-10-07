return require("util.lsp").ensure_lang({
  parsers = { "go", "gomod", "gowork", "gosum" },
  ft = { "go", "go.sum", "go.mod", "go.work" },
  tools = { "delve", "gopls" },
  formatters = { "goimports", "gofumpt", "golangci-lint", "golangci-lint-langserver" },
  other = {
    {
      "leoluz/nvim-dap-go",
      ft = "go",
      opts = {},
    },
    {
      "nvim-neotest/neotest-go",
      ft = "go",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
    },
    {
      "nvim-neotest/neotest",
      opts = {
        lazy_adapters = {
          function()
            return require("neotest-go")
          end,
        },
      },
    },
  },
})
