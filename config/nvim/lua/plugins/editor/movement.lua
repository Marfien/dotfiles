return {
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
    "nvim-mini/mini.jump",
    keys = { "t", "T", "f", "F" },
    version = "*",
    opts = {
      silent = true,
    },
  },
}
