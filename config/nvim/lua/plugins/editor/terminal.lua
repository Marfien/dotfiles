return {
  {
    "ingur/floatty.nvim",
    opts = {
      window = {
        width = 1.0,
        height = 0.3,
        v_align = "bottom",
      },
    },
    config = function(_, opts)
      local floatty = require("floatty").setup(opts)
      _G.floatty_toggle = floatty.toggle
    end,
    keys = {
      { "<c-_>", "<cmd>lua floatty_toggle()<cr>", desc = "Toggle Terminal", mode = { "n", "t" } },
    },
  },
}
