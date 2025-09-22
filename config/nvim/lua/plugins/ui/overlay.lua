return {
  {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = {
      timeout = 10000,
    },
    init = function()
      vim.notify = require("notify")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        separator_style = { "█", "█" },
        indicator = {
          style = "none",
        },
      },
    },
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
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "mawkler/modicator.nvim",
    event = "BufEnter",
    opts = {
      highlights = {
        use_cursorline_backgroukd = true,
      },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    event = "BufEnter",
    opts = {},
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>cc",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics",
      },
      {
        "<leader>cC",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>co",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Outline",
      },
      {
        "<leader>xl",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List",
      },
      {
        "<leader>xl",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List",
      },
    },
  },
}
