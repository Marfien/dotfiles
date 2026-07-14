local lsp_util = require("util.lsp")

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
})

-- kotlin
lsp_util.ensure_lang({
  ft = { "kt", "kts" },
  parsers = { "kotlin" },
  formatters = { "ktfmt" },
})

-- python
lsp_util.ensure_lang({
  parsers = { "python" },
  ft = { "py" },
  formatters = { "black" },
})

-- shell
lsp_util.ensure_lang({
  ft = { "sh", "zsh", "bash" },
  parsers = { "bash" },
  formatters = { "shfmt" },
})

-- terraform/tofu
lsp_util.ensure_lang({
  parsers = { "terraform" },
  ft = { "tf", "terraform", "hcl" },
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
  parsers = { "typescript", "javascript", "jsx", "tsx" },
})

lsp_util.ensure_lang({
  ft = { "nix" },
  formatters = { "nixfmt" },
})

return {}
