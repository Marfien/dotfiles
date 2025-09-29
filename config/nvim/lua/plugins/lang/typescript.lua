return require("util.lsp").ensure_lang({
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
