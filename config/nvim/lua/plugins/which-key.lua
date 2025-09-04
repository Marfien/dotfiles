return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      { "<leader>a", group = "AI" },
      { "<leader>g", group = "Git" },
      { "<leader>f", group = "Find" },
      { "<leader>b", group = "Buffer" },
      { "<leader>w", group = "Window" },
      { "<leader>.", group = "Management" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Debug" },
      { "<leader>t", group = "Test" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
