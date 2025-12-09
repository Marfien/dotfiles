vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { desc = "Alias to `:checkhealth vim.lsp`" })

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename()))
end, {
  desc = "Opens the Nvim LSP client log.",
})

vim.api.nvim_create_user_command("LspRestart", function()
  vim
    .iter(vim.lsp.get_clients())
    :map(function(client)
      return client.name
    end)
    :each(require("util.lsp").restart)
end, {
  desc = "Restarts all currently attached LSP clients",
})
