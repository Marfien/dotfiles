return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return vim.o.lines * 0.33
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
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
