return {
  {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {},
    },
    config = function(_, opts)
      require("mason").setup({})
      require("util.mason").setup(opts.ensure_installed)
      vim.keymap.set("n", "<localleader>mu", function()
        require("util.mason").performUpdate(opts.ensure_installed)
      end, {})
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
