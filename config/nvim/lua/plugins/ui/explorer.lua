return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      { "nvim-tree/nvim-web-devicons", opts = {} },
    },
    opts = {
      columns = {
        "size",
        "icon",
      },
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          return name == ".git"
        end,
      },
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
        ["ESC"] = { "actions.close", mode = "n" },
      },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
  },
  {
    "benomahony/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
  },
}
