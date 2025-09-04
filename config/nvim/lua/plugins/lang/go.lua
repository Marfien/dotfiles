return require("util.lsp").ensure_lang({
  ft = { "go", "gomod", "gowork", "gosum" },
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
