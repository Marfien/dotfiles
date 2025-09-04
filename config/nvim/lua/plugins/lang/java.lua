return require("util.lsp").ensure_lang({
  ft = { "java" },
  lsp = "jdtls",
  formatters = { "google-java-format" },
  dap = "java-debug-adapter",
  test_adapter = function()
    return require("neotest-java")()
  end,
  other = {
    {
      "mfussenegger/nvim-jdtls",
      ft = "java",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
      config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client or client.name ~= "jdtls" then
              return
            end

            require("jdtls").setup_dap({ hotcoderreplace = "auto" })
          end,
        })
      end,
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
