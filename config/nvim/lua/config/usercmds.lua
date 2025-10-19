vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { desc = "Alias to `:checkhealth vim.lsp`" })

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename()))
end, {
  desc = "Opens the Nvim LSP client log.",
})

vim.api.nvim_create_user_command("LspRestart", function()
  local clients = vim
    .iter(vim.lsp.get_clients())
    :map(function(client)
      return client.name
    end)
    :totable()

  for _, client in ipairs(clients) do
    vim.lsp.enable(client, false)
  end

  local timer = assert(vim.uv.new_timer())
  timer:start(500, 0, function()
    for _, name in ipairs(clients) do
      vim.schedule_wrap(function(x)
        vim.lsp.enable(x)
      end)(name)
    end
  end)
end, {
  desc = "Restarts all currently attached LSP clients",
})
