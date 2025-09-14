local spelling_suggestions = 5

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.spellsuggest = { "best", spelling_suggestions }
  end,
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
      { "<leader>r", group = "Refactor" },
      { "<leader>d", group = "Debug" },
      { "<leader>t", group = "Test" },
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
