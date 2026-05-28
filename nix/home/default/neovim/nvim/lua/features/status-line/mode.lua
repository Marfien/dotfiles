local accents = {
  default = { "%#StatusLineOuterNormal#", "%#StatusLineInnerNormal#", "%#StatusLineCenter#" },
  visual = { "%#StatusLineOuterVisual#", "%#StatusLineInnerVisual#", "%#StatusLineCenter#" },
  insert = { "%#StatusLineOuterInsert#", "%#StatusLineInnerInsert#", "%#StatusLineCenter#" },
  replace = { "%#StatusLineOuterReplace#", "%#StatusLineInnerReplace#", "%#StatusLineCenter#" },
  terminal = { "%#StatusLineOuterTerminal#", "%#StatusLineInnerTerminal#", "%#StatusLineCenter#" },
  other = { "%#StatusLineOuterInactive#", "%#StatusLineInnerInactive#", "%#StatusLineCenter#" },
}

local modes = {
  ["n"] = { "NORMAL", accents.default },
  ["no"] = { "NORMAL", accents.default },
  ["v"] = { "VISUAL", accents.visual },
  ["V"] = { "VISUAL LINE", accents.visual },
  [""] = { "VISUAL BLOCK", accents.visual },
  ["s"] = { "SELECT", accents.default },
  ["S"] = { "SELECT LINE", accents.default },
  [""] = { "SELECT BLOCK", accents.default },
  ["i"] = { "INSERT", accents.insert },
  ["ic"] = { "INSERT", accents.insert },
  ["R"] = { "REPLACE", accents.replace },
  ["Rv"] = { "VISUAL REPLACE", accents.replace },
  ["c"] = { "COMMAND", accents.other },
  ["cv"] = { "VIM EX", accents.other },
  ["ce"] = { "EX", accents.other },
  ["r"] = { "PROMPT", accents.other },
  ["rm"] = { "MOAR", accents.other },
  ["r?"] = { "CONFIRM", accents.other },
  ["!"] = { "SHELL", accents.terminal },
  ["t"] = { "TERMINAL", accents.terminal },
  fallback = { "UNKNOWN", accents.other },
}

local M = {}

M.key = "mode"

function M.get_current_mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return unpack(modes[current_mode] or modes.fallback)
end

local function update()
  local display, color = M.get_current_mode()

  local draw_cache = require("features.status-line.draw-cache")
  draw_cache.update(M.key, display)
  draw_cache.update("highlights", color)
end

function M.setup_autocmds(group)
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = update,
  })

  update()
end

return M
