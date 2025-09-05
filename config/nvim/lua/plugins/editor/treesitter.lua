return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
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
        "bash",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
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
