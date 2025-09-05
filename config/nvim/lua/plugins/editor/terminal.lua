return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      winbar = {
        enabled = true,
      },
    },
    keys = {
      { "<C-/>", "<cmd>ToggleTerm<cr>", desc = "Toggle Term", mode = { "n", "t" } },
      { "<c-_>", "<cmd>ToggleTerm<cr>", desc = "which_key_ignore", mode = { "n", "t" } },
      { "<esc><esc><esc>", "<C-\\><C-n>", desc = "Normal Mode", mode = { "t" } },
    },
  },
}
