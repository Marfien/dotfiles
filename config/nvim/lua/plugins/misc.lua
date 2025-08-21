-- TODO: windows user name from powershell
local snapshot_path = (vim.env.WSL_DISTRO_NAME and "/mnt/c/Users/maha/Pictures" or "~/Pictures") .. "/codesnaps/"

return {
  {
    "mistricky/codesnap.nvim",
    build = "make",
    keys = {
      { "<leader>cp", "<cmd>CodeSnap<cr>", mode = "v", desc = "Save selected code as snapshot to clipboard" },
      { "<leader>cP", "<cmd>CodeSnapSave<cr>", mode = "v", desc = "Save selected code as snapshot to in " },
    },
    opts = {
      save_path = snapshot_path,
      watermark = "",
      bg_theme = "bamboo",
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
}
