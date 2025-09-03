return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    event = "BufEnter",
    cmd = "LazyDev",
    dependencies = {
      "justinsgithub/wezterm-types",
    },
    opts = {
      library = {
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
    {
      "saghen/blink.cmp",
      dependencies = {
        "folke/lazydev.nvim",
      },
      opts = {
        sources = {
          default = { "lazydev" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        formatter = {
          "stylua",
        },
        lsp = {
          "lua-language-server",
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
      },
    },
  },
}
