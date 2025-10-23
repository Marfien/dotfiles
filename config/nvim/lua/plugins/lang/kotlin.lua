vim.api.nvim_create_autocmd("FileType", {
  pattern = "kotlin",
  callback = function(data)
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
      --"Marfien/android-nvim",
      dir = "~/Workspace/github/marfien/android-nvim/",
      cmd = { "AndroidBuildRelease", "AndroidRun", "AndroidClean", "LaunchAvd", "AndroidUninstall" },
      init = function()
        vim.env.ANDROID_SDK_HOME = vim.env.XDG_CONFIG_HOME
        vim.env.ANDROID_USER_HOME = vim.env.XDG_CONFIG_HOME .. "/.android/"
        vim.env.ANDROID_EMULATOR_HOME = vim.env.ANDROID_USER_HOME
        vim.env.ANDROID_AVD_HOME = vim.env.ANDROID_USER_HOME .. "/avd"
        vim.env.ANDROID_HOME = vim.env.WSL_DISTRO_NAME and vim.fn.stdpath("config") .. "/assets/android-sdk-wsl/"
          or require("util.brew").get_brew_path() .. "/share/android-commandlinetools"
      end,
      opts = {},
    },
  },
})
