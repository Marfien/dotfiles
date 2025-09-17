local brew_handle = io.popen("brew --prefix")
if not brew_handle then
  error("Brew Path could not be determined")
end

local brew_path = brew_handle:read("*a"):gsub("\n", "")
brew_handle:close()

-- throw error when brewPath nil
if not brew_path then
  vim.notify("Brew Path cannot be found. Disabling nvim-jdtls...")
  return false
end

local function get_openjdk_runtime(version)
  return {
    name = "JavaSE-" .. (version <= 8 and "1." .. version or version),
    path = brew_path .. "/opt/openjdk@" .. version .. "/bin",
  }
end

local function get_cache_dir()
  return (os.getenv("XDG_CACHE_HOME") or vim.uv.os_homedir() .. "/.cache") .. "/jdtls"
end

local function get_jdtls_jvm_args()
  -- add lombok
  local args = {}
  for a in string.gmatch((os.getenv("JDTLS_JVM_ARGS") or ""), "%S+") do
    local arg = string.format("--jvm-arg=%s", a)
    table.insert(args, arg)
  end
  return unpack(args)
end

local mason_dir = require("mason-core.installer.InstallLocation").global():get_dir()
local jdtls_dir = mason_dir .. "/packages/jdtls"

vim.lsp.config("jdtls", {
  cmd = {
    "jdtls",
    "-configuration",
    get_cache_dir() .. "/config",
    "-data",
    get_cache_dir() .. "/workspace",
    "--jvm-arg=-javaagent:" .. jdtls_dir .. "/lombok.jar",
    get_jdtls_jvm_args(),
  },
  bundles = vim.split(vim.fn.glob(mason_dir .. "/java-*/extension/server/*.jar", true), "\n"),
  settings = {
    java = {
      settings = {
        url = vim.fn.stdpath("config") .. "/assets/jdtls/settings.pref",
      },
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
      contentProvider = { preferred = "fernflower" },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      cleanup = {
        actionsOnSave = { "qualifyStaticMembers", "qualifyMembers", "addOverride" },
      },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        -- Filter jdk internal classes
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      saveActions = {
        organizeImports = true,
      },
      format = {
        enabled = true,
      },
      signatureHelp = { enabled = true },
      maven = {
        downloadSources = true,
      },
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        runtimes = {
          get_openjdk_runtime(8),
          get_openjdk_runtime(17),
          get_openjdk_runtime(21),
        },
        updateBuildConfiguration = "automatic",
      },
    },
  },
})

-- jdtls base config is provided by nvim-jdtls
vim.schedule(function()
  vim.lsp.enable("jdtls")
end)

return require("util.lsp").ensure_lang({
  ft = { "java" },
  --formatters = { "google-java-format" },
  tools = { "java-debug-adapter", "jdtls" },
  on_attach = function(buf)
    require("jdtls").setup_dap()

    local map = function(modes, rhs, lhs, desc)
      vim.keymap.set(modes, lhs, rhs, { desc = desc, buffer = buf })
    end

    map("n", "ro", "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports")
    map("n", "re", "<Cmd>lua require'jdtls'.extract_variable()<CR>", "Extract Variable")
    map("v", "re", "<ESC><Cmd>lua require'jdtls'.extract_variable(true)<CR>", "Extract Variable")
    map("n", "rc", "<Cmd>lua require'jdtls'.extract_constant()<CR>", "Extract Constant")
    map("v", "rc", "<ESC><Cmd>lua require'jdtls'.extract_constant(true)<CR>", "Extract Constant")
    map("v", "rm", "<ESC><Cmd>lua require'jdtls'.extract_method(true)<CR>", "Extract Method")
  end,
  other = {
    {
      "mfussenegger/nvim-jdtls",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
    },
    {
      "rcasia/neotest-java",
      ft = "java",
      build = ":NeotestJava setup",
      config = function() end,
      dependencies = {
        "mfussenegger/nvim-jdtls",
        "nvim-treesitter/nvim-treesitter",
        "mfussenegger/nvim-dap",
      },
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
