local spelling_suggestions = 5

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.spellsuggest = { "best", spelling_suggestions }
  end,
  opts = {
    preset = "helix",
    show_help = false,
    win = {
      border = vim.g.borderstyle.name,
    },
    spec = {
      { "<leader>a", group = "AI" },
      { "<leader>g", group = "Git" },
      { "<leader>gc", group = "Conflicts" },
      { "<leader>f", group = "Find" },
      { "<leader>b", group = "Buffer" },
      { "<leader>w", group = "Window" },
      { "<leader>.", group = "Management" },
      { "<leader>c", group = "Code" },
      { "<leader>r", group = "Refactor" },
      { "<leader>d", group = "Debug" },
      { "<leader>t", group = "Test" },
      { "<leader>s", group = "Session" },
    },
    plugins = {
      spelling = {
        suggestions = spelling_suggestions,
      },
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
