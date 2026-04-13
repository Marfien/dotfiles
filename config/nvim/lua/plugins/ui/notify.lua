local function hijack_builtin()
  print = function(err)
    vim.notify(err, vim.log.levels.INFO, { title = "Print" })
  end
end

return {
  {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = {
      stages = "fade",
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { border = vim.g.borderstyle.name })
      end,
    },
    config = function(_, opts)
      local mod = require("notify")
      mod.setup(opts)
      vim.notify = mod
      hijack_builtin()
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    cmd = "Fidget",
    opts = {
      progress = {
        ignore_empty_messages = true,
      },
      notification = {
        --poll_rate = math.huge,
      },
    },
  },
}
