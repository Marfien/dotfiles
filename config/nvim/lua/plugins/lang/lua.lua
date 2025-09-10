return require("util.lsp").ensure_lang({
  ft = { "lua" },
  lsps = { "lua-language-server" },
  formatters = { "stylua" },
  setup_refactor = true,
  other = {
    "justinsgithub/wezterm-types",
  },
})
