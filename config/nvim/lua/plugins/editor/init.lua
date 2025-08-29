return {
  {
    "nvim-mini/mini.pairs",
    event = "LazyFile",
    opts = {
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
}
