return {
  {
    "j-hui/fidget.nvim",
    lazy = false,
    config = function(_, opts)
      require("fidget").setup(opts)
      print = vim.notify
    end,
    opts = {
      notification = {
        override_vim_notify = true,
      },
    },
  },
}
