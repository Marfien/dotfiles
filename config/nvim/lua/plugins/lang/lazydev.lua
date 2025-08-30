return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    dependencies = {
      "justinsgithub/wezterm-types",
    },
    opts = {
      library = {
        "lazy.nvim",
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
    {
      "saghen/blink.cmp",
      opts = {
        sources = {
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
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
}
