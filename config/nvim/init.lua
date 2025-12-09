-- bootstrap lazy.nvim
require("config.options")
require("config.autocmds")
require("config.usercmds")
require("config.keymaps")

require("config.lazy")

vim.schedule(require("util.lsp").setup)
