vim.api.nvim_create_autocmd("User", {
  pattern = "ConformFormatPost",
  callback = function(event)
    print("CFP")
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == event.buf then
        vim.api.nvim_win_call(win, function()
          vim.api.nvim_feedkeys("zH", "n", false)
        end)
      end
    end
  end,
})

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
