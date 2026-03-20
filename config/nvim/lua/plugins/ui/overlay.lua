return {
  {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = {
      timeout = 10000,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { border = vim.g.borderstyle.name })
      end,
    },
    init = function()
      vim.notify = require("notify")
    end,
  },
  {
    "folke/noice.nvim",
    lazy = false,
    opts = {
      messages = {},
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      cmdline = {
        view = "cmdline",
      },
      views = {
        confirm = {
          border = {
            style = vim.g.borderstyle.name,
          },
        },
        cmdline_input = {
          border = {
            style = vim.g.borderstyle.name,
          },
        },
        popup = {
          border = {
            style = vim.g.borderstyle.name,
          },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
