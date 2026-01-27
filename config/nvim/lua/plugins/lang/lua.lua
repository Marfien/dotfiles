return require("util.lsp").ensure_lang({
  ft = { "lua" },
  tools = { "lua-language-server" },
  formatters = { "stylua" },
  other = {
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      dependencies = {
        "justinsgithub/wezterm-types",
      },
      opts = {
        integrations = {
          lspconfig = false,
        },
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          -- Load the wezterm types when the `wezterm` module is required
          -- Needs `justinsgithub/wezterm-types` to be installed
          { path = "wezterm-types", mods = { "wezterm" } },
        },
      },
    },
  },
})
