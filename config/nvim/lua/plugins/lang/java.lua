vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("java_close_imports", {}),
  callback = vim.schedule_wrap(function(event)
    if vim.api.nvim_buf_is_valid(event.buf) and vim.bo[event.buf].filetype ~= "java" then
      return
    end

    local success, first_lines = pcall(vim.api.nvim_buf_get_lines, event.buf, 0, 100, false)
    if not success then
      return
    end

    for line_num, line in ipairs(first_lines) do
      if line:find("class", 0, true) then
        return
      end

      if vim.startswith(line, "import") then
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, { line_num, 0 })
        pcall(vim.cmd.normal, { "zc", bang = true })
        vim.api.nvim_win_set_cursor(0, pos)
        return
      end
    end
  end),
})

return require("util.lsp").ensure_lang({
  ft = { "java" },
  tools = { "java-test", "java-debug-adapter", "jdtls" },
  build = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, "NeotestJava setup")
  end,
  other = {
    {
      "mfussenegger/nvim-jdtls",
      config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("java_setup_dap", {}),
          callback = function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.name == "jdtls" then
              require("jdtls.dap").setup_dap_main_class_configs()
            end
          end,
        })
      end,
    },
    {
      "atm1020/neotest-jdtls",
      branch = "handle-jdtls-unavailable",
      ft = "java",
      dependencies = {
        "mfussenegger/nvim-jdtls",
        "mfussenegger/nvim-dap",
      },
    },
    {
      "nvim-neotest/neotest",
      opts = {
        lazy_adapters = {
          function()
            return require("neotest-jdtls")
          end,
        },
      },
    },
  },
})
