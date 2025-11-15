local function diff_against(branch)
  vim.cmd("DiffviewOpen " .. branch .. "...HEAD")
end

return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    opts = {
      current_line_blame = true,
    },
    keys = {
      { "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<cr>", desc = "Preview Hunk" },
      { "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<cr>", desc = "Reset Hunk" },
      { "<leader>gR", "<cmd>lua require('gitsigns').reset_buffer()<cr>", desc = "Reset Buffer" },
      --{ "<leader>gd", "<cmd>lua require('gitsigns').diffthis()<cr>", desc = "Diff this" },
      { "ih", "<cmd>lua require('gitsigns').select_hunk()<cr>", desc = "Select Hunk", mode = { "o", "x" } },
      { "<leader>gx", require("util.git").open, desc = "Open in Browser" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {
      default_args = {
        DiffviewOpen = { "--imply-local" },
      },
      view = {
        default = {
          winbar_info = true,
        },
      },
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close View" } },
        },
        diff1 = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close View" } },
        },
        diff2 = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close View" } },
        },
        diff3 = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close View" } },
        },
        diff4 = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close View" } },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close View" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close View" } },
        },
      },
    },
    keys = {
      {
        "<leader>gc",
        function()
          local user_input = vim.fn.input("Compare to: ")
          if user_input ~= "" then
            diff_against(user_input)
          else
            vim.notify("Aboarding", vim.log.levels.ERROR)
          end
        end,
        desc = "Compare to Revision",
      },
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Repo Diff (Local Changes)" },
      {
        "<leader>gD",
        function()
          diff_against(require("util.git").get_default_branch())
        end,
        desc = "Repo Diff (Default Branch)",
      },
      { "<leader>gh", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "History (File)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "History (Repo)" },
    },
  },
}
