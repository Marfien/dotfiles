return {
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = {
      timeout = 20000,
    },
    init = function()
      vim.notify = require("notify")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_b = {
          LazyVim.lualine.root_dir({ cwd = true }),
          { "branch" },
        },
        lualine_c = {
          { LazyVim.lualine.pretty_path() },
          {
            "fileformat",
            icrons_enabled = true,
            symbols = {
              unix = "LF",
              dos = "CRLF",
              mac = "CR",
            },
          },
        },
        lualine_y = {
          { "location", padding = { left = 0, right = 1 } },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = true,
            exclude = { ".git" },
          },
        },
        hidden = true,
        ignored = true,
      },
    },
  },
}
