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
}
