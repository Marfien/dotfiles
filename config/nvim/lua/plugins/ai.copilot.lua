return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      server = {
        type = "binary",
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-\\>",
        },
      },
      panel = {
        enabled = false,
      },
      filetypes = {},
    },
  },
}
