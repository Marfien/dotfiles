return require("util.lsp").ensure_lang({
  ft = { "java" },
  lsps = { "jdtls" },
  --formatters = { "google-java-format" },
  tools = { "java-debug-adapter" },
  setup_refactor = true,
  test_adapter = function()
    return require("neotest-java")()
  end,
  on_attach = function(buf)
    require("jdtls").setup_dap()

    local map = function(modes, rhs, lhs, desc)
      vim.keymap.set(modes, lhs, rhs, { desc = desc, buffer = buf })
    end

    map("n", "ro", "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports")
    map("n", "re", "<Cmd>lua require'jdtls'.extract_variable()<CR>", "Extract Variable")
    map("v", "re", "<ESC><Cmd>lua require'jdtls'.extract_variable(true)<CR>", "Extract Variable")
    map("n", "rc", "<Cmd>lua require'jdtls'.extract_constant()<CR>", "Extract Constant")
    map("v", "rc", "<ESC><Cmd>lua require'jdtls'.extract_constant(true)<CR>", "Extract Constant")
    map("v", "rm", "<ESC><Cmd>lua require'jdtls'.extract_method(true)<CR>", "Extract Method")
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
