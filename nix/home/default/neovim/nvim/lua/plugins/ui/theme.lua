return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    -- schedule to somewhat delay it but before event = "VeryLazy"
    opts = {
      on_highlights = function(hl, colors)
        hl.LineNr                  = { fg = colors.fg_dark }
        hl.LineNrAbove             = hl.LineNr
        hl.LineNrBelow             = hl.LineNr
        hl.VertSplit               = hl.LineNr
        hl.WinSeparator            = hl.LineNr

        hl.StatusLineCenter        = { bg = colors.bg_statusline, fg = colors.fg_sidebar }
        hl.StatusLineOuterNormal   = { bg = colors.blue, fg = colors.black }
        hl.StatusLineInnerNormal   = { bg = colors.fg_gutter, fg = colors.blue }
        hl.StatusLineOuterVisual   = { bg = colors.magenta, fg = colors.black }
        hl.StatusLineInnerVisual   = { bg = colors.fg_gutter, fg = colors.magenta }
        hl.StatusLineOuterInsert   = { bg = colors.green, fg = colors.black }
        hl.StatusLineInnerInsert   = { bg = colors.fg_gutter, fg = colors.green }
        hl.StatusLineOuterReplace  = { bg = colors.red, fg = colors.black }
        hl.StatusLineInnerReplace  = { bg = colors.fg_gutter, fg = colors.red }
        hl.StatusLineOuterTerminal = { bg = colors.green1, fg = colors.black }
        hl.StatusLineInnerTerminal = { bg = colors.fg_gutter, fg = colors.green1 }
        hl.StatusLineOuterInactive = { bg = colors.bg_statusline, fg = colors.blue }
        hl.StatusLineInnerInactive = { bg = colors.bg_statusline, fg = colors.fg_gutter }
      end,
      plugins = {
        lualine = true,
      },
    },
    init = function()
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
