return require("util.lsp").ensure_lang({
  ft = { "kt", "kts" },
  formatters = { "ktfmt" },
  tools = { "ktfmt", "kotlin-lsp" },
  other = {
    {
      "ariedov/android-nvim",
      cmd = { "AndroidBuildRelease", "AndroidRun", "AndroidClean", "LaunchAvd", "AndroidUninstall" },
      init = function()
        vim.g.android_sdk = require("util.brew").get_brew_path() .. "/share/android-commandlinetools"
      end,
      opts = {},
    },
  },
})
