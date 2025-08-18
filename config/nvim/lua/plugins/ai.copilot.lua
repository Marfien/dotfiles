return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false, -- disable copilot to make programming fun again
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
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      window = {
        layout = "float",
        width = 0.6,
        height = 0.6,
        border = "rounded",
      },
      headers = {
        user = " 👤 You: ",
        assistant = " 🤖 Copilot: ",
        tool = " 🔧 Tool: ",
      },
      show_folds = true,
    },
  },
}
