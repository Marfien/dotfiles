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

      vim.keymap.set("t", "<ESC><ESC><ESC>", "<C-\\><C-n>", { desc = "Go to normal mode" })
    end,
    keys = {
      { "<c-/>", "<cmd>lua floatty_toggle()<cr>", desc = "Toggle Terminal", mode = { "n", "t" } },
      { "<c-_>", "<cmd>lua floatty_toggle()<cr>", desc = "which_key_ignore", mode = { "n", "t" } },
    },
  },
}
