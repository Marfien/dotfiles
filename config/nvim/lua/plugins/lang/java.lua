vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("java_close_imports", {}),
  callback = function(event)
    if vim.bo.filetype ~= "java" then
      return
    end

    local first_lines = vim.api.nvim_buf_get_lines(event.buf, 0, 100, false)

    for line_num, line in ipairs(first_lines) do
      if line:find("class", 0, true) then
        return
      end

      if vim.startswith(line, "import") then
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, { line_num, 0 })
        vim.cmd.normal({ "zc", bang = true })
        vim.api.nvim_win_set_cursor(0, pos)
        return
      end
    end
  end,
})

return require("util.lsp").ensure_lang({
  ft = { "java" },
  tools = { "java-test", "java-debug-adapter", "jdtls" },
  other = {
    {
      "mfussenegger/nvim-jdtls",
      dependencies = {
        -- dap will be enabled automatically when required - ig
        --"mfussenegger/nvim-dap",
      },
    },
    {
      "rcasia/neotest-java",
      ft = "java",
      dependencies = {
        "mfussenegger/nvim-jdtls",
        "mfussenegger/nvim-dap", -- for the debugger
        "rcarriga/nvim-dap-ui", -- recommended
        "theHamsta/nvim-dap-virtual-text", -- recommended
      },
      config = function()
        vim.cmd("NeotestJava setup")
      end,
    },
    {
      "nvim-neotest/neotest",
      opts = {
        lazy_adapters = {
          function()
            return require("neotest-java")
          end,
        },
      },
    },
  },
})
