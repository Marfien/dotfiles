return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts_extend = {
      "ensure_installed",
    },
    opts = {
      ensure_installed = {
        "css",
        "ruby",
        "csv",
        "dockerfile",
        "editorconfig",
        "git_config",
        "helm",
        "html",
        "http",
        "jq",
        "pug",
        "sql",
      },
      highlight = {
        enabled = true,
      },
      indent = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
  },
}
