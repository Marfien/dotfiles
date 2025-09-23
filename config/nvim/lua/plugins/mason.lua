local mason_to_x = {
  ["lua-language-server"] = "lua_ls",
  ["java-debug-adapter"] = "java-adapter",
  ["terraform-ls"] = "terraformls",
  ["yaml-language-server"] = "yamlls",
  ["bash-language-server"] = "bashls",
}

return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonLog" },
    init = function()
      pcall(vim.cmd, "MsonUpdate")
    end,
    opts = {},
    keys = {
      { "<leader>.m", "<cmd>Mason<cr>", desc = "Mason" },
      { "<leader>.p", "<cmd>LspInfo<cr>", desc = "LspInfo" },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {},
    },
    opts_extend = {
      "ensure_installed",
    },
  },
}
