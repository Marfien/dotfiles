return {
  {
    "saghen/blink.cmp",
    lazy = false, -- handled by plugin
    version = "0.*",
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "v2.*" },
      {
        "micangl/cmp-vimtex",
        ft = "tex",
        opts = {},
      },
    },
    opts = {
      snippets = {
        preset = "luasnip",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "vimtex" },
        providers = {
          vimtex = {
            name = "vimtex",
            module = "blink.compat.source",
            score_offset = 3,
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
  {
    -- compatibiltiy lazyer for vim cmp and blink
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },
}
