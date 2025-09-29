return {
  {
    "windwp/nvim-autopairs",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = "InsertEnter",
    opts = {
      check_ts = true,
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    version = "*",
    event = "BufEnter",
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
      },
      scope = {
        show_start = false,
        show_end = false,
        highlight = "CursorLine",
      },
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
  },
  {
    "chrishrb/gx.nvim",
    keys = {
      { "gx", "<cmd>Browse<cr>", mode = { "n", "x" }, desc = "Open in Browser" },
    },
    cmd = "Browse",
    init = function()
      vim.g.netrw_nogx = 1
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    submodules = false,
    opts = function(opts)
      opts = opts or {}

      if vim.env.WSL_DISTRO_NAME then
        opts.open_browser_app = vim.env.WSL_DISTRO_NAME and "powershell.exe" or "os_specific"
        opts.open_browser_args = { "start", "explorer.exe" }
      end

      return opts
    end,
  },
  {
    "retran/meow.yarn.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("meow.yarn").setup({})
    end,
    keys = {
      { "<leader>cS", "<Cmd>MeowYarn call callers<CR>", desc = "Call Stack", mode = { "n", "x" } },
    },
  },
  {
    "samiulsami/fFtT-highlights.nvim",
    opts = {
      max_highlighted_lines_around_cursor = 50,
      match_highlight = {
        highlight_radius = 50,
      },
      multi_line = {
        enable = true,
        max_lines = 50,
      },
    },
    config = function(_, opts)
      require("fFtT-highlights"):setup(opts)
    end,
    keys = { "f", "F", "t", "T" },
  },
}
