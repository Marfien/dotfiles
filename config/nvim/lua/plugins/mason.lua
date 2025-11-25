return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonLog" },
    config = function(_, opts)
      require("mason").setup(opts)

      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, "MsonUpdate")
    end,
    opts = {},
    keys = {
      { "<leader>.m", "<cmd>Mason<cr>", desc = "Mason" },
      { "<leader>.p", "<cmd>LspInfo<cr>", desc = "LspInfo" },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {},
      auto_update = true,
    },
    opts_extend = {
      "ensure_installed",
    },
  },
}
