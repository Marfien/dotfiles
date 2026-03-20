-- bootstrap lazy.nvim
require("config.options")
require("config.keymaps")

require("config.lazy")

require("util.dashboard").setup()
vim.schedule(function()
  require("util.lsp").setup()
  require("config.usercmds")
  require("config.autocmds")
end)
