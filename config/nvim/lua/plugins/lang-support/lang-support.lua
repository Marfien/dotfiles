vim.api.nvim_create_autocmd("User", {
  pattern = "ConformFormatPost",
  callback = function(event)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == event.buf then
        vim.api.nvim_win_call(win, function()
          vim.api.nvim_feedkeys("2zH", "n", false)
        end)
      end
    end
  end,
})

return {
  {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>.m", "<cmd>Mason<cr>", desc = "Mason" },
      { "<leader>.p", "<cmd>LspInfo<cr>", desc = "LspInfo" },
    },
  },
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
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    opts = {
      preset = "classic",
      options = {
        multilines = {
          enabled = true,
        },
        show_all_diags_on_cursorline = true,
        break_line = {
          enabled = true,
        },
      },
    },
    init = function()
      vim.diagnostic.config({
        virtual_text = false,
        signs = false,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "enter",

        ["<c-j>"] = { "select_next", "fallback_to_mappings" },
        ["<c-k>"] = { "select_prev", "show_signature", "hide_signature", "fallback_to_mappings" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        ghost_text = { enabled = true },
        menu = {
          draw = {
            columns = {
              { "kind_icon", "label", gap = 1 },
              { "label_description" },
              { "source_name" },
            },
          },
        },
      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
    keys = {
      { "<leader>.b", "<cmd>BlinkCmp status<cr>", { desc = "BlinkCmp" } },
    },
  },
}
