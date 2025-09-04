return require("util.lsp").ensure_lang({
  parsers = { "terraform" },
  ft = { "tf", "terraform", "hcl" },
  lsp = "terraform-ls",
})
