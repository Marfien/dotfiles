return require("util.lsp").ensure_lang({
  ft = { "sh", "zsh", "bash" },
  parsers = { "bash" },
  lsp = "bash-language-server",
  formatters = { "shfmt" },
  linters = { "shellcheck" },
})
