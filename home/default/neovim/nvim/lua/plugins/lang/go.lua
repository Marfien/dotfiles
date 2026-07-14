return require("util.lsp").ensure_lang({
  parsers = { "go", "gomod", "gowork", "gosum" },
  ft = { "go", "gosum", "gomod", "gowork" },
  formatters = { "goimports-reviser", "gofumpt" },
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
