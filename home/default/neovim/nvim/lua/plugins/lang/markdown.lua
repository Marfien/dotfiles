return require("util.lsp").ensure_lang({
  parsers = { "markdown", "markdown_inline", "html" },
  ft = { "md", "markdown" },
  formatters = { "prettier" },
  other = {
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "copilot-chat" },
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
        file_types = { "markdown", "copilot-chat" }
      },
    },
  },
})
