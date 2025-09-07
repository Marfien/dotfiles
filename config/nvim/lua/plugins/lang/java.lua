return require("util.lsp").ensure_lang({
  ft = { "java" },
  lsp = "jdtls",
  formatters = { "google-java-format" },
  dap = "java-debug-adapter",
  setup_refactor = true,
  test_adapter = function()
    return require("neotest-java")()
  end,
  on_attach = function()
    require("jdtls").setup_dap({ hotcoderreplace = "auto" })
  end,
  other = {
    {
      "mfussenegger/nvim-jdtls",
      ft = "java",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
    },
    {
      "rcasia/neotest-java",
      ft = "java",
      build = ":NeotestJava setup",
      config = function() end,
      dependencies = {
        "mfussenegger/nvim-jdtls",
        "nvim-treesitter/nvim-treesitter",
        "mfussenegger/nvim-dap",
      },
    },
  },
})
