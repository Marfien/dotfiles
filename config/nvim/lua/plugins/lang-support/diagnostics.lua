return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
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
    init = function()
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
    },
    keys = {
      { "<leader>ft", "<cmd>:TodoTelescope<cr>", desc = "Find TODOs" },
    },
  },
}
