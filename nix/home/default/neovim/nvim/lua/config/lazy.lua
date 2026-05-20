require("lazy").setup({
  lockfile = vim.fn.stdpath("state") .. "/lazy/lazy-lock.json",
  ui = {
    border = vim.g.borderstyle.name,
  },
  spec = {
    -- Spell files for German and English
    "AlxHnr/vim-spell-files",
    -- bit hacky to exclude lazy.nvim from updates as it is managed by nix/home-manager
    { 'folke/lazy.nvim',              enabled = false, },
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
