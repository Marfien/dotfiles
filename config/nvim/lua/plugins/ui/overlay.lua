local paths = require("util.paths")

return {
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
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "AndreM222/copilot-lualine" },
    },
    opts = {
      sections = {
        lualine_a = { "mode" },
        lualine_b = { --󱉭
          function()
            return "󱉭 " .. vim.fs.basename(paths.project_root())
          end,
          { "branch" },
        },
        lualine_c = {
          {
            function()
              return paths.pretty_path(paths.project_root())
            end,
          },
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
            -- display debugger information
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
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
