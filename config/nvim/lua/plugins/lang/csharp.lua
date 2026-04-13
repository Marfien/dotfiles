vim.lsp.config("roslyn", {
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

local function setup_dap()
  local dotnet_root = require("util.brew").get_brew_path() .. "/opt/dotnet/libexec"

  vim.fn.setenv("DOTNET_ROOT", dotnet_root)
  vim.notify("Setting DOTNET_ROOT = " .. dotnet_root)

  local dap = require("dap")

  dap.adapters.coreclr = {
    type = "executable",
    command = require("mason-core.installer.InstallLocation").global():bin("netcoredbg"),
    args = { "--interpreter=vscode" },
  }

  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "launch",
      program = function()
        local proj_file = vim.fs.find(function(name)
          return name:match("%.csproj$")
        end, { upward = true, type = "file", path = vim.api.nvim_buf_get_name(0) })[1]
        local proj_dir = proj_file and vim.fs.dirname(proj_file) or vim.fn.getcwd()

        return vim.fn.input("Path to dll: ", proj_dir .. "/bin/Debug/", "file")
      end,
    },
  }
end

return require("util.lsp").ensure_lang({
  parsers = { "c_sharp" },
  ft = { "cs" },
  tools = { "roslyn", "netcoredbg" },
  formatters = { "clang-format" },
  other = {
    {
      "mason-org/mason.nvim",
      opts = {
        registries = {
          "github:Crashdummyy/mason-registry",
        },
      },
    },
    {
      "seblyng/roslyn.nvim",
      lazy = false,
      config = function()
        vim.schedule(setup_dap)
        require("roslyn").setup({})
      end,
    },
  },
})
