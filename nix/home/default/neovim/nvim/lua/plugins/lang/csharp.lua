return require("util.lsp").ensure_lang({
  parsers = { "c_sharp" },
  ft = { "cs" },
  formatters = { "csharpier" },
  other = {
    {
      "GustavEikaas/easy-dotnet.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
      build = function()
        vim.uv.new_async(function()
          vim.notify("Installing dotnet tooling:\n EasyDotnet, dotnet-ef")
          vim.system({ "dotnet", "tool", "install", "--global", "EasyDotnet" }):wait()
          vim.system({ "dotnet", "tool", "install", "--global", "dotnet-ef" }):wait()
          vim.notify("Successfully installed dotnet tooling")
        end)
      end,
      cmd = "Dotnet",
      ft = "cs",
      opts = {
        notifications = {
          managed_terminal = {
            auto_hide = false,
          },
          handler = function()
            return function(finished_event)
              vim.notify(finished_event.result.msg, finished_event.result.level, { title = "EasyDotnet" })
            end
          end,
        },
      },
      keys = {
        { "<localleader>cX", "Dotnet ", ft = "cs" },
      },
    },
  },
})
