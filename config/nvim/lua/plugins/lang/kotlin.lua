vim.api.nvim_create_autocmd("FileType", {
  pattern = "kotlin",
  callback = function()
    vim.env.ANDROID_USER_HOME = vim.env.XDG_CONFIG_HOME .. "/android/"
    vim.env.ANDROID_HOME = vim.env.WSL_DISTRO_NAME and vim.fn.stdpath("config") .. "/assets/android-sdk-wsl/"
      or require("util.brew").get_brew_path() .. "/share/android-commandlinetools"
    require("util.android").setup()
  end,
})

return require("util.lsp").ensure_lang({
  ft = { "kt", "kts" },
  parsers = { "kotlin" },
  formatters = { "ktfmt" },
  tools = { "ktfmt", "kotlin-lsp" },
  other = {
    {
      "Marfien/astudio.nvim",
      cmd = "Android",
      opts = {},
    },
  },
})
