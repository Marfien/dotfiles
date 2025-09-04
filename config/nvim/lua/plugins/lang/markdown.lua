return require("util.lsp").lang_support("markdown", nil, { "prettier" }, {
  {
    "MeanderingProgrammer/render-markdown.nvim",
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
})
