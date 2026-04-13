return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    -- schedule to somewhat delay it but before event = "VeryLazy"
    opts = {
      on_highlights = function(hl, c)
        hl.LineNr = { fg = c.fg_dark }
        hl.LineNrAbove = hl.LineNr
        hl.LineNrBelow = hl.LineNr
        hl.VertSplit = hl.LineNr
        hl.WinSeparator = hl.LineNr
      end,
    },
    init = vim.schedule(function()
      vim.cmd("colorscheme tokyonight")
    end),
  },
}
