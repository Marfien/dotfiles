return {
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      vim.g.vimtex_view_method = "sioyek"

      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_complete_enabled = 1

      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "build/aux/",
        out_dir = "build/out/",
      }
    end,
  },
}
