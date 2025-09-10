return require("util.lsp").ensure_lang({
  parsers = { "go", "gomod", "gowork", "gosum" },
  ft = { "go", "go.sum", "go.mod", "go.work" },
  lsps = { "gopls" },
  tools = { "delve" },
  formatters = { "goimports", "gofumpt" },
  test_adapter = function()
    return require("neotest-go")
  end,
  setup_refactor = true,
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
