return require("util.lsp").ensure_lang({
  ft = { "java" },
  tools = { "java-test", "java-debug-adapter", "jdtls", "vscode-spring-boot-tools" },
  other = {
    {
      "mfussenegger/nvim-jdtls",
      dependencies = {
        -- dap will be enabled automatically when required - ig
        --"mfussenegger/nvim-dap",
      },
    },
    {
      "rcasia/neotest-java",
      ft = "java",
      dependencies = {
        "mfussenegger/nvim-jdtls",
        "mfussenegger/nvim-dap", -- for the debugger
        "rcarriga/nvim-dap-ui", -- recommended
        "theHamsta/nvim-dap-virtual-text", -- recommended
      },
      config = function()
        vim.cmd("NeotestJava setup")
      end,
    },
    {
      "nvim-neotest/neotest",
      opts = {
        lazy_adapters = {
          function()
            return require("neotest-java")
          end,
        },
      },
    },
  },
})
