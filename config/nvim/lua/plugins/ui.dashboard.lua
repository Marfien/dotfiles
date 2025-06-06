return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          {
            section = "terminal",
            cmd = "catimg ~/.config/nvim/assets/dashboard.png; sleep .001",
            height = 17,
            pane = 1,
          },
          {
            pane = 2,
            section = "keys",
            height = 17,
            gap = 1,
          },
        },
      },
    },
  },
}
