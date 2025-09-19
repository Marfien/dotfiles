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
  {
    "StackInTheWild/headhunter.nvim",
    config = function()
      local headhhunter = require("headhunter")

      vim.api.nvim_create_user_command(
        "HeadhunterNext",
        headhhunter.next_conflict,
        { desc = "Go to next Git conflict" }
      )
      vim.api.nvim_create_user_command(
        "HeadhunterPrevious",
        headhhunter.prev_conflict,
        { desc = "Go to previous Git conflict" }
      )

      vim.api.nvim_create_user_command("HeadhunterTakeHead", headhhunter.take_head, {})
      vim.api.nvim_create_user_command("HeadhunterTakeOrigin", headhhunter.take_origin, {})
      vim.api.nvim_create_user_command("HeadhunterTakeBoth", headhhunter.take_both, {})
    end,
    keys = {
      { "]g", "<cmd>HeadhunterNext<cr>", desc = "Next Git Merge Conflict" },
      { "[g", "<cmd>HeadhunterPrevious<cr>", desc = "Previous Git Merge Conflict" },
      { "<leader>gco", "<cmd>HeadhunterTakeOrigin<cr>", desc = "Take Origin" },
      { "<leader>gch", "<cmd>HeadhunterTakeHead<cr>", desc = "Take Head" },
      { "<leader>gcb", "<cmd>HeadhunterTakeBoth<cr>", desc = "Take Both" },
    },
  },
}
