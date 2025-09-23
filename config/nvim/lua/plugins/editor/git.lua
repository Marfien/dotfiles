local function get_default_branch_name()
  local res = vim.system({ "git", "rev-parse", "--verify", "main" }, { capture_output = true }):wait()
  return res.code == 0 and "main" or "master"
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
    },
    keys = {
      {
        "<leader>gc",
        function()
          local user_input = vim.fn.input("Compare to: ")
          vim.cmd("DiffviewOpen " .. user_input)
        end,
        desc = "Compare to Revision",
      },
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Repo Diff (Local Changes)" },
      {
        "<leader>gD",
        function()
          vim.cmd("DiffviewOpen " .. get_default_branch_name())
        end,
        desc = "Repo Diff (Default Branch)",
      },
      { "<leader>gh", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "History (File)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "History (Repo)" },
    },
  },
}
