vim.lsp.config("roslyn", {
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

vim.schedule(function()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client or client.name ~= "roslyn" then
        return
      end

      vim.api.nvim_buf_set_keymap(
        event.buf,
        "n",
        "<localleader>cr",
        "<cmd>lua require('util.csharp').run()",
        { desc = "Run charp programm" }
      )
    end,
  })
end)

return require("util.lsp").ensure_lang({
  parsers = { "c_sharp" },
  ft = { "cs" },
  tools = { "roslyn" },
  formatters = { "clang-format" },
  other = {
    {
      "mason-org/mason.nvim",
      opts = {
        registries = {
          "github:Crashdummyy/mason-registry",
        },
      },
    },
    {
      "seblyng/roslyn.nvim",
      lazy = false,
      opts = {},
    },
  },
})
