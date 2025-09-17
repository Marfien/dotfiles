return require("util.lsp").ensure_lang({
  parsers = { "python" },
  ft = { "py" },
  tools = { "debugpy", "jedi-language-server" },
  formatters = { "black" },
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
    },
    {
      "nvim-neotest/neotest",
      opts = {
        lazy_adapters = {
          function()
            return require("neotest-python")
          end,
        },
      },
    },
  },
})
