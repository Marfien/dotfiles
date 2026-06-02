local M = {}

M.key = "recording"

local status_message = ""
local function update()
  require("features.status-line.draw-cache").update(M.key, status_message)
end

function M.setup_autocmds(group)
  vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
    group = group,
    callback = function(ev)
      status_message = ev.event == "RecordingEnter" and "%#Constant#@" .. vim.fn.reg_recording() or ""
      update()
    end,
  })
  update()
end

return M
