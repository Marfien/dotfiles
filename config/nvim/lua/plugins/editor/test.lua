return {
  {
    "nvim-neotest/neotest",
    event = "BufReadPost",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {},
    },
    opts_extend = {
      "adapters",
    },
    config = function(_, opts)
      for i, provider in ipairs(opts.adapters) do
        opts.adapters[i] = provider()
      end

      require("neotest").setup(opts)
    end,
    keys = {
      { "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", desc = "Test Nearest" },
      { "<leader>ta", "<cmd>lua require('neotest').run.run({suite = true})<cr>", desc = "Test All" },
      { "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest" },
      { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Test File" },
      { "<leader>ts", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop" },

      { "<leader>to", "<cmd>lua require('neotest').output.open()<cr>", desc = "Open Output" },
      { "<leader>tm", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle Summary" },
      { "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Toggle Output Panel" },
    },
  },
}
