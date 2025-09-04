return {
  {
    "saghen/blink.cmp",
    event = { "BufEnter" },
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
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1, "source_name" },
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
