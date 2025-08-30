return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-tree/nvim-web-devicons", opts = {} },
      "folke/noice.nvim",
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
      telescope.load_extension("noice")
    end,
    -- stylua: ignore
    keys = {
      { "<leader><space>", function() require("telescope.builtin").find_files() end, desc = "Telescope find files" },
      { "<leader>fl", function() require("telescope.builtin").live_grep() end, desc = "Telescope live grep" },
      { "<leader>fs", function() require("telescope.builtin").grep_string() end, desc = "Telescope grep string" },
      { "<leader>fm", function() "<cmd>Telescope noice<cr>", desc = "Telescope grep string" },
    },
  },
}
