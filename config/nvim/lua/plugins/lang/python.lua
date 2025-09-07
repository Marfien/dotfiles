return require("util.lsp").ensure_lang({
  parsers = { "python" },
  setup_refactor = true,
  ft = { "py" },
  lsp = "jedi-language-server",
  formatters = { "black" },
  test_adapter = function()
    require("neotest-python")
  end,
  dap = "debugpy",
  other = {
    {
      "mfussenegger/nvim-dap-python",
      ft = "py",
      config = function()
        require("dap-python").setup("uv")
      end,
    },
    {
      "nvim-neotest/neotest-python",
      ft = "py",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      opst = {
        python = nil,
      },
    },
  },
})
