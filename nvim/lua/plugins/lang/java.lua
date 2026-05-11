return require("util.lsp").ensure_lang({
  ft = { "java" },
  build = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, "NeotestJava setup")
  end,
  other = {
    {
      "mfussenegger/nvim-jdtls",
      config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("java_setup_dap", {}),
          callback = function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.name == "jdtls" then
              require("jdtls.dap").setup_dap_main_class_configs()
            end
          end,
        })
      end,
    },
    {
      "atm1020/neotest-jdtls",
      ft = "java",
      dependencies = {
        "mfussenegger/nvim-jdtls",
        "mfussenegger/nvim-dap",
      },
    },
    {
      "nvim-neotest/neotest",
      opts = {
        lazy_adapters = {
          function()
            return require("neotest-jdtls")
          end,
        },
      },
    },
  },
})
