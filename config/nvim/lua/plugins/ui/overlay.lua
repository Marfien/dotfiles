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
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
      },
    },
  },
  {
    "folke/noice.nvim",
    lazy = false,
    opts = {
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
    opts = {
      highlights = {
        use_cursorline_backgroukd = true,
      },
    },
  },
}
