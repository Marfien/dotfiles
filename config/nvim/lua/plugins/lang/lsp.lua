return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
    },
    opts_extend = { "ensure_installed" },
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "lua_ls",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonLog" },
    build = ":MasonUpdate",
    opts = {},
    keys = {
      { "<leader>.m", "<cmd>Mason<cr>", desc = "Mason" },
      { "<leader>.p", "<cmd>LspInfo<cr>", desc = "LspInfo" },
    },
  },
}
