local M = {}

function M.ensure_treesitter(ft)
  return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = ft,
    },
  }
end

function M.ensure_formatters(ft, pkgs)
  return {
    M.ensure_tools(pkgs),
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          [ft] = pkgs,
        },
      },
    },
  }
end

function M.ensure_tools(pkg)
  return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = pkg,
    },
  }
end

---@class util.lsp.LangSpec
---@field tools? table<string>
---@field parsers? table<string>
---@field ft table
---@field formatters? table
---@field other? table<string>

---Definition
---@param opts util.lsp.LangSpec
---@return table
function M.ensure_lang(opts)
  opts = opts or {}
  local plugins = opts.other or {}

  table.insert(plugins, M.ensure_treesitter(opts.parsers or opts.ft))

  if opts.formatters then
    for _, ft in ipairs(opts.ft) do
      for _, pl in ipairs(M.ensure_formatters(ft, opts.formatters)) do
        table.insert(plugins, pl)
      end
    end
  end

  if opts.tools then
    table.insert(plugins, M.ensure_tools(opts.tools))
  end

  return plugins
end

function M.setup()
  local lsp_configs = vim.api.nvim_get_runtime_file("lsp/*.lua", true)
  for _, config in ipairs(lsp_configs) do
    local id = vim.fs.basename(config):gsub("%.lua$", "")
    vim.lsp.enable(id)
  end
end

return M
