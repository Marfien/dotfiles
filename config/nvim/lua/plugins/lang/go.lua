return require("util.lsp").lang_support("go", "gopls", { "goimport", "gofumpt" }, {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "gomod",
        "gowork",
        "gosum",
      },
    },
  },
})
