return require("util.lsp").ensure_lang({
  ft = { "lua" },
  lsp = "lua-language-server",
  formatters = { "stylua" },
  other = {
    "justinsgithub/wezterm-types",
  },
})
