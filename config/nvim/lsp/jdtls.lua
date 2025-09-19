local InstallLocation = require("mason-core.installer.InstallLocation")
local jdtls = require("jdtls")

InstallLocation.global():initialize()

------- JDK Discovery -------

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
    path = brew_path .. "/opt/openjdk@" .. version .. "/",
  }
end

------- CMD and Args -------

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

local global = InstallLocation.global()
local lombok_jar = global:package("jdtls") .. "/lombok.jar"

-- Using vim.lsp.config as it has higher priority as files inside lsp/
vim.lsp.config("jdtls", {
  cmd = {
    "jdtls",
    "-configuration",
    get_cache_dir() .. "/config",
    "-data",
    get_cache_dir() .. "/workspace",
    "--jvm-arg=-javaagent:" .. lombok_jar,
    get_jdtls_jvm_args(),
  },
})

------- Bundles -------
local bundle_globs = {
  global:package("java-debug-adapter") .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
  global:package("java-test") .. "/extension/server/*.jar",
}

local found_bundles = {}
for _, glob in ipairs(bundle_globs) do
  for _, file in ipairs(vim.split(vim.fn.glob(glob, true), "\n")) do
    table.insert(found_bundles, file)
  end
end

local excluded = {
  "", -- empty lines are possible
  "com.microsoft.java.test.runner-jar-with-dependencies.jar",
  "jacocoagent.jar",
}

local bundles = {
  require("spring_boot").java_extensions(),
}
for _, bundle in ipairs(found_bundles) do
  local filename = vim.fn.fnamemodify(bundle, ":t")
  if not vim.tbl_contains(excluded, filename) then
    table.insert(bundles, bundle)
  end
end

------- Actual Config -------

---@type vim.lsp.Config
return {
  init_options = {
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    bundles = bundles,
  },
  on_attach = function(_, buf)
    jdtls.setup_dap()

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
  settings = {
    java = {
      autobuild = { enabled = false },
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
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
          useInstanceOf = true,
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          get_openjdk_runtime(8),
          get_openjdk_runtime(17),
          get_openjdk_runtime(21),
        },
        updateBuildConfiguration = "automatic",
      },
      contentProvider = { preferred = "fernflower" },
      eclipse = {
        downloadSources = true,
      },
      format = {
        enabled = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
      maven = {
        downloadSources = true,
      },
      maxConcurrentBuilds = 8,
      saveActions = {
        organizeImports = true,
      },
      settings = {
        url = vim.fn.stdpath("config") .. "/assets/jdtls/settings.pref",
      },
      signatureHelp = { enabled = true },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },
}
