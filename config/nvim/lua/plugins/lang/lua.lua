vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*",
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or client.name ~= "lua_ls" then
      return
    end

    vim.keymap.set("n", "<leader>cR", function()
      local libs = client.config.settings.Lua.workspace.library or {}
      table.insert(libs, vim.api.nvim_get_runtime_file("", true))
      vim.lsp.config("lua_ls", {
        Settings = {
          Lua = {
            workspace = {
              library = libs,
            },
          },
        },
      })
    end, { buffer = event.buf, desc = "Attach full Runtime" })
  end,
})

return require("util.lsp").ensure_lang({
  ft = { "lua" },
  lsp = "lua-language-server",
  formatters = { "stylua" },
  other = {
    "justinsgithub/wezterm-types",
  },
})
