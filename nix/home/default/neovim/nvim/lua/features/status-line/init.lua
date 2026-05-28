local M = {}

local buf_counter = require("features.status-line.buf-counter")
local lsp_info = require("features.status-line.lsp-info")
local mode = require("features.status-line.mode")
local rec_msg = require("features.status-line.recording-msg")
local util = require("features.status-line.util")

function M.setup()
  local layout = {
    { mode.key }, { util.key.project_dir, util.key.git_branch }, { buf_counter.key, util.key.filename },
    { lsp_info.key, rec_msg }, { util.key.fileformat, util.key.fileencoding }, { util.key.cursor_position }
  }

  local augroup = vim.api.nvim_create_augroup("status-line", {})
  buf_counter.setup_autocmds(augroup)
  lsp_info.setup_autocmds(augroup)
  mode.setup_autocmds(augroup)
  rec_msg.setup_autocmds(augroup)
  util.setup_autocmds(augroup)

  require("features.status-line.draw-cache").draw(layout)
end

return M
