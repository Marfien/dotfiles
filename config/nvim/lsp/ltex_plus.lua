local function find_spelling_mistake(forward)
  local all_diagnostics = vim.diagnostic.get(0, { severity = "INFO" })

  -- Filter for ltex diagnostics
  local ltex_diagnostics = {}
  for _, diagnostic in ipairs(all_diagnostics) do
    if diagnostic.source and diagnostic.source:lower():match("ltex") then
      table.insert(ltex_diagnostics, diagnostic)
    end
  end

  if #ltex_diagnostics == 0 then
    return nil
  end

  -- Sort diagnostics by position
  table.sort(ltex_diagnostics, function(a, b)
    if a.lnum == b.lnum then
      return a.col < b.col
    end
    return a.lnum < b.lnum
  end)

  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1] - 1 -- Convert to 0-based
  local current_col = cursor[2]

  local target_diagnostic = nil

  if forward then
    -- Find next diagnostic
    for _, diagnostic in ipairs(ltex_diagnostics) do
      if diagnostic.lnum > current_line or (diagnostic.lnum == current_line and diagnostic.col > current_col) then
        target_diagnostic = diagnostic
        break
      end
    end

    -- If no next diagnostic found, wrap to first
    target_diagnostic = target_diagnostic or ltex_diagnostics[1]
  else
    -- Find previous diagnostic (iterate backwards)
    for i = #ltex_diagnostics, 1, -1 do
      local diagnostic = ltex_diagnostics[i]
      if diagnostic.lnum < current_line or (diagnostic.lnum == current_line and diagnostic.col < current_col) then
        target_diagnostic = diagnostic
        break
      end
    end

    -- If no previous diagnostic found, wrap to last
    target_diagnostic = target_diagnostic or ltex_diagnostics[#ltex_diagnostics]
  end

  return target_diagnostic
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("ltex-keymap", {}),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or client.name ~= "ltex_plus" then
      return
    end

    vim.keymap.set("n", "]s", function()
      local diag = find_spelling_mistake(true)
      if diag ~= nil then
        vim.diagnostic.jump({ diagnostic = diag })
      end
    end, { buffer = event.buf, desc = "Next spell" })

    vim.keymap.set("n", "[s", function()
      local diag = find_spelling_mistake(false)
      if diag ~= nil then
        vim.diagnostic.jump({ diagnostic = diag })
      end
    end, { buffer = event.buf, desc = "Previous spell" })
  end,
})

local language_id_mapping = {
  bib = "bibtex",
  pandoc = "markdown",
  plaintex = "tex",
  rnoweb = "rsweave",
  rst = "restructuredtext",
  tex = "latex",
  text = "plaintext",
}

---@type vim.lsp.Config
return {
  cmd = { "ltex-ls-plus" },
  filetypes = {
    "bib",
    "context",
    "gitcommit",
    "html",
    "markdown",
    "org",
    "pandoc",
    "plaintex",
    "quarto",
    "mail",
    "mdx",
    "rmd",
    "rnoweb",
    "rst",
    "tex",
    "text",
    "typst",
    "xhtml",
  },
  root_markers = { ".git" },
  get_language_id = function(_, filetype)
    return language_id_mapping[filetype] or filetype
  end,
  settings = {
    ltex = {
      language = "auto",
      enabled = {
        "bib",
        "context",
        "gitcommit",
        "html",
        "markdown",
        "org",
        "pandoc",
        "plaintex",
        "quarto",
        "mail",
        "mdx",
        "rmd",
        "rnoweb",
        "rst",
        "tex",
        "latex",
        "text",
        "typst",
        "xhtml",
      },
    },
  },
}
