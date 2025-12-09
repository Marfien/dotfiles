return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonLog" },
    opts = {
      ensure_installed = {},
    },
    config = function(_, opts)
      require("mason").setup({})
      require("util.mason").setup(opts.ensure_installed)
    end,
    opts_extend = {
      "ensure_installed",
    },
    keys = {
      { "<leader>.m", "<cmd>Mason<cr>", desc = "Mason" },
      { "<leader>.p", "<cmd>LspInfo<cr>", desc = "LspInfo" },
    },
  },
}
