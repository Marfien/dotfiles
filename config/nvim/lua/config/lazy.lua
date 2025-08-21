local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.autocmds")
require("config.keymaps")

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.lang" },
    { import = "plugins.ui" },
    { import = "plugins.editor" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "catppuccin" } },
  checker = {
    enabled = true,
    notify = true,
  },
  browser = vim.env.WSL_DISTRO_NAME and "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" or nil,
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
