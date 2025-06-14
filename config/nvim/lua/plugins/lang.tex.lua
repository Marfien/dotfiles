return {
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      -- configure viewer
      vim.g.vimtex_view_method = "sioyek"
      if vim.env.WSL_DISTRO_NAME then
        -- Windows path is appended so we will use the windows version
        vim.g.vimtex_view_sioyek_exe = "sioyek.exe"
      end

      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_complete_enabled = 1

      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "build/aux/",
        out_dir = "build/out/",
      }
    end,
  },
}
