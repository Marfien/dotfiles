return require("util.lsp").ensure_lang({
  parsers = { "go", "gomod", "gowork", "gosum" },
  ft = { "go", "sum", "mod", "work" },
  lsp = "gopls",
  formatters = { "goimports", "gofumpt" },
  dap = "delve",
  test_adapter = function()
    return require("neotest-go")
  end,
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
  },
})
