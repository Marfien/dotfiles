return require("util.lsp").ensure_lang({
  ft = { "lua" },
  lsp = "lua-language-server",
  formatters = { "stylua" },
  setup_refactor = true,
  on_attach = function(buf, client)
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
    end, { buffer = buf, desc = "Attach full Runtime" })
  end,
  other = {
    "justinsgithub/wezterm-types",
  },
})
