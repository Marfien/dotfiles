return require("util.lsp").ensure_lang({
  parsers = { "python" },
  ft = { "py" },
  lsps = { "jedi-language-server" },
  tools = { "debugpy" },
  formatters = { "black" },
  test_adapter = function()
    require("neotest-python")
  end,
  setup_refactor = true,
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
