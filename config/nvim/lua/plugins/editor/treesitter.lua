return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    init = function()
      pcall(vim.cmd, "TSUpdate")
    end,
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
        "json",
      },
      highlight = {
        enable = true,
      },
      textobjects = {
        select = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "Function" },
          ["if"] = { query = "@function.inner", desc = "Function" },
          ["ac"] = { query = "@class.outer", desc = "Class" },
          ["ic"] = { query = "@class.inner", desc = "Class" },
          ["as"] = { query = "@local.scope", query_group = "locals", desc = "Lang Scope" },
        },
        selection_modes = {
          ["@function.outer"] = "V",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
