local lsp_util = require("util.lsp")

lsp_util.ensure_tools({ "lemminx", "ltex-ls-plus" })
lsp_util.ensure_treesitter({
  "css",
  "ruby",
  "csv",
  "dockerfile",
  "editorconfig",
  "git_config",
  "helm",
  "html",
  "http",
  "jq",
  "pug",
  "sql",
})

-- json
lsp_util.ensure_lang({
  ft = { "json", "json5" },
  formatters = { "prettier" },
  tools = { "json-lsp" },
})

-- kotlin
lsp_util.ensure_lang({
  ft = { "kt", "kts" },
  parsers = { "kotlin" },
  formatters = { "ktfmt" },
  tools = { "ktfmt", "kotlin-lsp" },
})

-- python
lsp_util.ensure_lang({
  parsers = { "python" },
  ft = { "py" },
  tools = { "debugpy", "jedi-language-server" },
  formatters = { "black" },
})

-- shell
lsp_util.ensure_lang({
  ft = { "sh", "zsh", "bash" },
  parsers = { "bash" },
  tools = { "bash-language-server", "shellcheck" },
  formatters = { "shfmt" },
})

-- terraform/tofu
lsp_util.ensure_lang({
  parsers = { "terraform" },
  ft = { "tf", "terraform", "hcl" },
  tools = { "tofu-ls", "tflint" },
})

-- js/ts
lsp_util.ensure_lang({
  ft = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  formatters = { "prettier" },
  tools = { "vtsls" },
  parsers = { "typescript", "javascript", "jsx", "tsx" },
})

return {}
