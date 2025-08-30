return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-tree/nvim-web-devicons", opts = {} },
    },
    opts = {
      defaults = {
        mappings = {
          n = {
            ["q"] = "close",
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      telescope.load_extension("fzf")
    end,
    keys = {
      { "<leader><space>", require("telescope.builtin").find_files, desc = "Telescope find files" },
      { "<leader>fl", require("telescope.builtin").live_grep, desc = "Telescope live grep" },
      { "<leader>fs", require("telescope.builtin").grep_string, desc = "Telescope grep string" },
    },
  },
}
