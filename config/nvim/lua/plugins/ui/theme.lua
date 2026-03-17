return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("tokyonight").setup({
        on_highlights = function(hl, c)
          hl.LineNr = { fg = c.fg_dark }
          hl.LineNrAbove = hl.LineNr
          hl.LineNrBelow = hl.LineNr
          hl.VertSplit = hl.LineNr
          hl.WinSeparator = hl.LineNr
        end,
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
