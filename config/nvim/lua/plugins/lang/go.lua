return require("util.lsp").ensure_lang({
  parsers = { "go", "gomod", "gowork", "gosum", "goworksum" },
  ft = { "go", "gosum", "gomod", "gowork", "goworksum" },
  tools = { "delve", "gopls", "golangci-lint", "golangci-lint-langserver" },
  formatters = { "goimports", "gofumpt" },
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
            return require("neotest-go")({
              experimental = {
                test_table = true,
              },
            })
          end,
        },
      },
    },
  },
})
