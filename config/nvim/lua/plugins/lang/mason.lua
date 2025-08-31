return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
    keys = {
      { "<leader>.m", "<cmd>Mason<cr>", desc = "Open Mason UI" },
    },
  },
}
