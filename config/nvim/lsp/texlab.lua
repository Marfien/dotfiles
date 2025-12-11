-- Lazy init siojek path
local forawrdSearchExecutable = "sioyek"
if vim.env.WSL_DISTRO_NAME then
  local sioyekPathData = vim
    .system({
      "powershell.exe",
      "-nologo",
      "-noprofile",
      "-command",
      "wsl wslpath (get-command sioyek).Source.Replace('\\', '\\\\')",
    })
    :wait()
  if sioyekPathData.code ~= 0 then
    error("Determinaning forwardSearch executable path was unsuccessfull: \n" .. sioyekPathData.stderr)
  end
  forawrdSearchExecutable = sioyekPathData.stdout:gsub("\n", "")
end

local outdir = "build/out/"
local auxdir = "build/aux/"

---@type vim.lsp.Config
return {
  cmd = { "texlab" },
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
        executable = forawrdSearchExecutable,
        args = {
          "--reuse-window",
          "--execute-command",
          "toggle_synctex",
          "--inverse-search",
          'texlab inverse-search -i "%%1" -l %%2',
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
        ["local"] = nil, -- local is a reserved keyword
        modifyLineBreaks = false,
      },
      bibtexFormatter = "texlab",
      formatterLineLength = 80,
    },
  },
}
