local paths = require("util.paths")

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    --{ "AndreM222/copilot-lualine" },
    { "nvim-tree/nvim-web-devicons" },
    { "folke/noice.nvim" },
  },
  init = function()
    vim.opt.laststatus = 3
  end,
  opts = {
    globalstatus = true,
    options = {
      section_separators = "",
      component_separators = { left = "│", right = "│" },
    },
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
          color = function()
            local bufname = vim.api.nvim_buf_get_name(0)
            local new = vim.fn.filereadable(bufname) == 0 and vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg
              or nil
            local modified = vim.bo.modified and vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg or nil
            local fg = modified or new or vim.api.nvim_get_hl(0, { name = "Normal" }).fg
            return { fg = string.format("#%06X", fg) }
          end,
        },
      },
      lualine_x = {
        { "lsp_status" },
        --{ "copilot" },
        {
          require("noice").api.status.mode.get,
          cond = require("noice").api.status.mode.has,
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
