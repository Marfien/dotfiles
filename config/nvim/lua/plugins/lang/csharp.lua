vim.env.PATH = vim.env.PATH .. ":" .. vim.fs.abspath("~/.dotnet/tools/")
vim.env.DOTNET_ROOT = require("util.brew").get_brew_path() .. "/opt/dotnet/libexec"

return require("util.lsp").ensure_lang({
  parsers = { "c_sharp" },
  ft = { "cs" },
  -- netcoredbg must be compiled for Apple Silicon
  tools = (jit.os == "OSX" and jit.arch == "arm64") and { "roslyn" } or { "roslyn", "netcoredbg" },
  formatters = { "csharpier" },
  other = {
    {
      "GustavEikaas/easy-dotnet.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
      build = function()
        vim.notify("Installing dotnet tooling:\n EasyDotnet, dotnet-ef")
        vim.system({ "dotnet", "tool", "install", "--global", "EasyDotnet" }):wait()
        vim.system({ "dotnet", "tool", "install", "--global", "dotnet-ef" }):wait()
        vim.notify("Successfully installed dotnet tooling")
      end,
      ft = "cs",
      opts = {
        notifications = {
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
