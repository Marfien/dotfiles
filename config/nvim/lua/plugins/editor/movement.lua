return {
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "BufEnter",
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
  },
  {
    "nvim-mini/mini.jump",
    version = "*",
    keys = { "t", "T", "f", "F" },
    opts = {
      silent = true,
      delay = {
        highlight = math.pow(2, 16),
      },
    },
  },
}
