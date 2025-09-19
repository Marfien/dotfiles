return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufEnter",
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
        char = "▍",
        show_start = false,
        show_end = false,
        highlight = "IblIndent",
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
    opts = {},
  },
  {
    "retran/meow.yarn.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    keys = {
      { "<leader>cS", "<Cmd>MeowYarn call callers<CR>", desc = "Call Stack", mode = { "n", "x" } },
    },
  },
}
