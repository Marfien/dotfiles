local M = {}

local buf_counter = require("features.status-line.buf-counter")
local lsp_info = require("features.status-line.lsp-info")
local mode = require("features.status-line.mode")
local rec_msg = require("features.status-line.recording-msg")
local other = require("features.status-line.other")
local filename = require("features.status-line.filename")

function M.setup()
  local layout = {
    { mode.key }, { other.key.project_dir, other.key.git_branch }, { buf_counter.key, filename.key },
    { lsp_info.key, rec_msg }, { other.key.fileformat, other.key.fileencoding }, { other.key.cursor_position }
  }

  vim.schedule(function()
    local augroup = vim.api.nvim_create_augroup("status-line", {})
    for _, comp in ipairs({ buf_counter, lsp_info, mode, rec_msg, other, filename }) do
      comp.setup_autocmds(augroup)
    end
    require("features.status-line.draw-cache").draw(layout)
  end)
end

return M
