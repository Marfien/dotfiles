return require("util.lsp").ensure_lang({
  ft = { "sh", "zsh", "bash" },
  parsers = { "bash" },
  lsps = { "bash-language-server", "shellcheck" },
  formatters = { "shfmt" },
})
