return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    opts = {
      current_line_blame = true,
    },
    keys = {
      { "<leader>gh", "<cmd>lua require('gitsigns').preview_hunk()<cr>", desc = "Preview Hunk" },
      { "<leader>gH", "<cmd>lua require('gitsigns').reset_hunk()<cr>", desc = "Reset Hunk" },
      { "<leader>gR", "<cmd>lua require('gitsigns').reset_buffer()<cr>", desc = "Reset Buffer" },
      { "<leader>gd", "<cmd>lua require('gitsigns').diffthis()<cr>", desc = "Diff this" },
      { "ih", "<cmd>lua require('gitsigns').select_hunk()<cr>", desc = "Select Hunk", mode = { "o", "x" } },
    },
  },
}
