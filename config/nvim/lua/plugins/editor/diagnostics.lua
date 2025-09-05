return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      preset = "classic",
      options = {
        multilines = {
          enabled = true,
        },
        show_all_diags_on_cursorline = true,
        break_line = {
          enabled = true,
        },
      },
    },
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)
      vim.diagnostic.config({
        virtual_text = false,
        signs = false,
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = "TodoTelescope",
    event = { "BufReadPost" },
    opts = {
      signs = false,
      pattern = "\b(KEYWORDS)\b",
    },
    keys = {
      { "<leader>ft", "<cmd>:TodoTelescope<cr>", desc = "Find TODOs" },
    },
  },
}
