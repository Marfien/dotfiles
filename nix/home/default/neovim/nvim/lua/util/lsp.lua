local M = {}

local ts_parsers = {}
local formatters_by_ft = {}

---@param parsers string[]
function M.ensure_treesitter(parsers)
  vim.list_extend(ts_parsers, parsers)
end

---@param filetypes string[]
---@param pkgs string[]
function M.ensure_formatters(filetypes, pkgs)
  if not pkgs and not filetypes then
    return
  end

  local map = {}
  for _, ft in ipairs(filetypes) do
    map[ft] = pkgs
  end

  formatters_by_ft = vim.tbl_extend("error", formatters_by_ft, map)
end

---@class util.lsp.LangSpec
---@field parsers? string[]
---@field ft string[]
---@field formatters? table
---@field other? table

---Definition
---@param opts util.lsp.LangSpec
---@return table
function M.ensure_lang(opts)
  opts = opts or {}

  M.ensure_treesitter(opts.parsers or opts.ft)
  M.ensure_formatters(opts.ft, opts.formatters)

  return opts.other or {}
end

function M.setup()
  vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
  })
  local lsp_configs = vim.api.nvim_get_runtime_file("lsp/*.lua", true)
  for _, config in ipairs(lsp_configs) do
    local id = vim.fs.basename(config):gsub("%.lua$", "")
    vim.lsp.enable(id)
  end

  require("conform").formatters_by_ft = formatters_by_ft
  require("nvim-treesitter").install(ts_parsers, { summary = true })
end

---@param client string the name of the client to restart
---@param delay? integer the delay
function M.restart(client, delay)
  vim.lsp.enable(client, false)
  local timer = assert(vim.uv.new_timer())
  timer:start(delay or 500, 0, function()
    vim.schedule_wrap(vim.lsp.enable)(client)
  end)
end

return M
