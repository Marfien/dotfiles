-- bootstrap lazy.nvim
require("config.options")
require("config.keymaps")
require("config.autocmds")

require("config.lazy")

require("util.dashboard").setup()

vim.defer_fn(function()
  require("util.lsp").setup()
  require("config.usercmds")
end, 100)
