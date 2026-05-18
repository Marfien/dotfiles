local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local res = vim
    .system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }, { text = true })
    :wait()
  if res.code ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { res.stderr, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  lockfile = vim.fn.stdpath("state") .. "/lazy/lazy-lock.json",
  ui = {
    border = vim.g.borderstyle.name,
  },
  spec = {
    -- Spell files for German and English
    "AlxHnr/vim-spell-files",
    { import = "plugins" },
    { import = "plugins.lang-support" },
    { import = "plugins.ui" },
    { import = "plugins.lang" },
  },
  install = {
    colorscheme = { "tokyonight", "habamax" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = {
    enabled = true,
    notify = true,
    frequency = 93600, -- once every day
  },
  change_detection = {
    enabled = false,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "man",
        "matchit",
        "net",
        "netrwPlugin",
        "rplugin",
        "spellfile",
        "tarPlugin",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
