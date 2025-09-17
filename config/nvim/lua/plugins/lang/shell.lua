return require("util.lsp").ensure_lang({
  ft = { "sh", "zsh", "bash" },
  parsers = { "bash" },
  tools = { "bash-language-server", "shellcheck" },
  formatters = { "shfmt" },
})
