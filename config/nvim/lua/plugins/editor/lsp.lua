return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonLog" },
    build = ":MasonUpdate",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {},
    keys = {
      { "<leader>.m", "<cmd>Mason<cr>", desc = "Mason" },
      { "<leader>.p", "<cmd>LspInfo<cr>", desc = "LspInfo" },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      ensure_installed = {
        lsp = {},
        dap = {},
        formatter = {},
        linter = {},
      },
    },
    config = function(_, opts)
      local mti_opts_ensure_installed = {}

      for _, val in ipairs(opts.ensure_installed.lsp) do
        table.insert(mti_opts_ensure_installed, val)
      end
      for _, val in ipairs(opts.ensure_installed.dap) do
        table.insert(mti_opts_ensure_installed, val)
      end
      for _, val in ipairs(opts.ensure_installed.linter) do
        table.insert(mti_opts_ensure_installed, val)
      end
      for _, val in ipairs(opts.ensure_installed.formatter) do
        table.insert(mti_opts_ensure_installed, val)
      end

      require("mason-tool-installer").setup({ ensure_installed = mti_opts_ensure_installed })

      for _, lsp in ipairs(opts.ensure_installed.lsp) do
        local lspconfig_name = require("mason-lspconfig.mappings").get_mason_map().package_to_lspconfig[lsp] or lsp
        vim.lsp.enable(lspconfig_name)
      end

      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- on_attach
      vim.api.nvim_create_autocmd("LspAttach", require("util.lsp").autocmd())
    end,
    opts_extend = {
      "ensure_installed.lsp",
      "ensure_installed.dap",
      "ensure_installed.formatter",
      "ensure_installed.linter",
    },
  },
}
