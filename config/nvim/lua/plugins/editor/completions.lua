return {
  {
    "saghen/blink.compat",
    version = "2.*",
    lazy = true,
    opts = {},
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "L3MON4D3/LuaSnip" },
    },
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    opts = {
      snippets = { preset = "luasnip" },
      keymap = { preset = "enter" },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true },
    },
  },
}
