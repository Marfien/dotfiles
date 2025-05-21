return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "csv",
        "dockerfile",
        "editorconfig",
        "git_config",
        "git_rebase",
        "gitignore",
        "helm",
        "html",
        "http",
        "java",
        "javascript",
        "jq",
        "json",
        "json5",
        "latex",
        "python",
        "regex",
        "sql",
        "tmux",
        "toml",
        "tsx",
        "typescript",
        "yaml",
        "latex",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      server = {
        type = "binary",
      },
    },
  },
}
