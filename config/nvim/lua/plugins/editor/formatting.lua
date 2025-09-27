return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      log_level = vim.log.levels.WARN,
      notify_on_error = true,
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
    keys = {
      { "<leader>.c", "<cmd>ConformInfo<cr>", desc = "Conform" },
    },
  },
}
