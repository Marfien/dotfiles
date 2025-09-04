return require("util.lsp").ensure_lang({
  parsers = { "markdown" },
  ft = { "md", "markdown" },
  formatters = { "prettier" },
  other = {
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = "md",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
      opts = {
        checkbox = {
          enabled = true,
        },
        completions = {
          lsp = {
            enabled = true,
          },
        },
      },
    },
  },
})
