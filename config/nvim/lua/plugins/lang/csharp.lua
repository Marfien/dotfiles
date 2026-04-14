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
  local netcoredbg_exec = vim.fn.exepath("netcoredbg")

  if netcoredbg_exec == "" then
    vim.notify("Cannot find netcoredbg executable in $PATH", vim.log.levels.ERROR)
    return
  end

  vim.fn.setenv("DOTNET_ROOT", dotnet_root)

  local dap = require("dap")

  dap.adapters.coreclr = {
    type = "executable",
    command = netcoredbg_exec,
    args = { "--interpreter=vscode" },
  }

  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "auto launch - netcoredbg",
      request = "launch",
      program = function()
        local proj_file = vim.fs.find(function(name)
          return name:match("%.csproj$")
        end, { upward = true, type = "file", path = vim.api.nvim_buf_get_name(0) })[1]
        local proj_dir = proj_file and vim.fs.dirname(proj_file) or vim.fn.getcwd()
        local project_name = vim.fs.basename(proj_dir)

        local glob = proj_dir .. "/bin/Debug/" .. "net*/*" .. project_name .. (jit.os == "Windows" and ".dll" or "")
        local exec = vim.trim(vim.fn.glob(glob))

        if exec ~= "" then
          vim.notify("Found executable:\n " .. vim.fs.relpath(vim.fn.getcwd(), exec))
          return exec
        else
          vim.notify("Cannot find executable automatically with glob: \n" .. glob, vim.log.levels.ERROR)
          return nil
        end
      end,
    },
    {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "launch",
      program = function()
        local proj_file = vim.fs.find(function(name)
          return name:match("%.csproj$")
        end, { upward = true, type = "file", path = vim.api.nvim_buf_get_name(0) })[1]
        local proj_dir = proj_file and vim.fs.dirname(proj_file) or vim.fn.getcwd()

        return vim.fn.input("Path to executable: ", proj_dir .. "/bin/Debug/", "file")
      end,
    },
  }
end

return require("util.lsp").ensure_lang({
  parsers = { "c_sharp" },
  ft = { "cs" },
  -- netcoredbg must be compiled for Apple Silicon
  tools = (jit.os == "OSX" and jit.arch == "arm64") and { "roslyn" } or { "roslyn", "netcoredbg" },
  formatters = { "csharpier" },
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
