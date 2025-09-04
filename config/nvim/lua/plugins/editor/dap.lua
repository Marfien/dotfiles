return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    opts_extend = {
      "dap.adapters",
    },
    keys = {
      { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
      {
        "<leader>dB",
        "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Condition: '))<cr>",
        desc = "Breakpoint Condition",
      },
      { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Run/Continue" },
      { "<leader>dC", "<cmd>lua require('dap').run_to_cursor()<cr>", desc = "Run to Cursor" },
      { "<leader>dp", "<cmd>lua require('dap').pause()<cr>", desc = "Pause" },
      { "<leader>dt", "<cmd>lua require('dap').terminate()<cr>", desc = "Terminate" },

      { "<Down>", "<cmd>lua require('dap').setup_over()<cr>", desc = "Setup Over" },
      { "<Left>", "<cmd>lua require('dap').setup_out()<cr>", desc = "Setup Out" },
      { "<Right>", "<cmd>lua require('dap').setup_into()<cr>", desc = "Setup Into" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    opts = {},
    config = function(_, opts)
      local dapui = require("dapui")
      local dap = require("dap")

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      dapui.setup(opts)
    end,
    keys = {
      { "<leader>dd", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
      { "<leader>de", "<cmd>lua require('dapui').eval()<cr>", desc = "Eval", mode = { "n", "v" } },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
}
