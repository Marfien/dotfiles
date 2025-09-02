return {
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
    keys = {
      { "<leader>.c", "<cmd>ConformInfo<cr>", { desc = "Conform" } },
    },
  },
}
