vim.api.nvim_create_autocmd("FileType", {
  pattern = "kotlin",
  callback = function(event)
    vim.api.nvim_buf_set_keymap(event.buf, "n", "<localleader>ai", "<cmd>Android install<cr>", { desc = "Install" })
    vim.api.nvim_buf_set_keymap(event.buf, "n", "<localleader>au", "<cmd>Android uninstall<cr>", { desc = "Uninstall" })
    vim.api.nvim_buf_set_keymap(event.buf, "n", "<localleader>al", "<cmd>Android logcat<cr>", { desc = "Logcat" })
    vim.api.nvim_buf_set_keymap(event.buf, "n", "<localleader>af", "<cmd>Android focus<cr>", { desc = "Focus" })
    vim.api.nvim_buf_set_keymap(
      event.buf,
      "n",
      "<localleader>aac",
      "<cmd>Android avd create<cr>",
      { desc = "AVD Create" }
    )
    vim.api.nvim_buf_set_keymap(
      event.buf,
      "n",
      "<localleader>aad",
      "<cmd>Android avd delete<cr>",
      { desc = "AVD Delete" }
    )
    vim.api.nvim_buf_set_keymap(
      event.buf,
      "n",
      "<localleader>aal",
      "<cmd>Android avd launch<cr>",
      { desc = "AVD Launch" }
    )
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
      init = function()
        vim.env.ANDROID_USER_HOME = vim.env.XDG_CONFIG_HOME .. "/android/"
        vim.env.ANDROID_HOME = vim.env.WSL_DISTRO_NAME and vim.fn.stdpath("config") .. "/assets/android-sdk-wsl/"
          or require("util.brew").get_brew_path() .. "/share/android-commandlinetools"
      end,
    },
  },
})
