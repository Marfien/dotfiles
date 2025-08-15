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
    "petertriho/nvim-scrollbar",
    opts = function()
      local colors = require("tokyonight.colors").setup()
      return {}
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "AndreM222/copilot-lualine" },
    },
    opts = {
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          LazyVim.lualine.root_dir(),
          { "branch" },
        },
        lualine_c = {
          { LazyVim.lualine.pretty_path() },
        },
        lualine_x = {
          {
            "fileformat",
            icrons_enabled = true,
            symbols = {
              unix = "LF",
              dos = "CRLF",
              mac = "CR",
            },
          },
          {
            "encoding",
            icons_enabled = true,
          },
          { "copilot" },
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function()
              return { fg = Snacks.util.color("Constant") }
            end,
          },
          {
            -- display debugger information
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            color = function()
              return { fg = Snacks.util.color("Debug") }
            end,
          },
        },
        lualine_y = {
          { "location" },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
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
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
}
