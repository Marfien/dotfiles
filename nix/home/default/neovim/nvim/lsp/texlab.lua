-- Lazy init siojek path
local outdir = "build/out/"
local auxdir = "build/aux/"

local texlab_path = vim.fn.exepath("texlab")

---@type vim.lsp.Config
return {
  cmd = { texlab_path },
  filetypes = { "tex", "plaintex", "bib" },
  root_markers = { ".git", ".latexmkrc", "latexmkrc", ".texlabroot", "texlabroot", "Tectonic.toml" },
  settings = {
    texlab = {
      rootDirectory = nil,
      build = {
        executable = "latexmk",
        args = {
          "-pdf",
          "-auxdir=" .. auxdir,
          "-outdir=" .. outdir,
          "-interaction=nonstopmode",
          "-synctex=1",
          "%f",
        },
        onSave = true,
        forwardSearchAfter = false,
        pdfDirectory = outdir,
      },
      forwardSearch = {
        executable = vim.fn.stdpath("config") .. "/assets/texlab/sioyek",
        args = {
          "--reuse-window",
          "--execute-command",
          "toggle_synctex",
          --"--inverse-search",
          --(vim.env.WSL_DISTRO_NAME and "wsl -- " or "") .. texlab_path .. ' inverse-search -i "%%1" -l %%2',
          "--forward-search-file",
          "%f",
          "--forward-search-line",
          "%l",
          "%p",
        },
      },
      chktex = {
        onOpenAndSave = false,
        onEdit = false,
      },
      diagnosticsDelay = 300,
      latexFormatter = "latexindent",
      latexindent = {
        ["local"] = nil,
        modifyLineBreaks = false,
      },
      bibtexFormatter = "texlab",
      formatterLineLength = 120,
    },
  },
}
