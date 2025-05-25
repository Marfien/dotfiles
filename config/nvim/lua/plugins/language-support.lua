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
        "typescript",
        "yaml",
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
  {
    "lervag/vimtex",
    lazy = false, -- already lazy loaded
    init = function()
      vim.g.vimtex_view_method = "sioyek"

      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_complete_enabled = 1

      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "build/aux/",
        out_dir = "build/out/",
      }
    end,
  },
}
