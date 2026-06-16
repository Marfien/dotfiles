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

vim.api.nvim_create_user_command("SpellStop", function()
  vim.opt_local.spell = false
end, { desc = "Enables spell checking for the current buffer" })

vim.api.nvim_create_user_command("SpellStart", function()
  local opt = vim.opt_local
  opt.spell = true
  opt.spelllang = { "en", "de" }
  opt.spelloptions = { "camel" }
  opt.smartcase = true
end, { desc = "Enables spell checking for the current buffer" })
