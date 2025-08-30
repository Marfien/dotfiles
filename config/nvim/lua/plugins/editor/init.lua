return {
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufEnter",
    opts = {},
  },
}
