return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    { "AndreM222/copilot-lualine" },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    { "folke/noice.nvim" },
  },
  opts = {
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
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
        { "lsp_status" },
        { "copilot" },
        {
          require("noice").api.statusline.mode.get,
          cond = require("noice").api.statusline.mode.has,
          color = { fg = "#ff9e64" },
        },
      },
      lualine_y = {
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
      },
      lualine_z = {
        { "location" },
        { "selectioncount" },
      },
    },
  },
}
