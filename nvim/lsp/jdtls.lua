local jdtls = require("jdtls")
local assets_path = vim.fn.stdpath("config") .. "/assets/jdtls"

------- JDK Discovery -------
local function get_openjdk_runtime(version)
  return {
    name = "JavaSE-" .. (version <= 8 and "1." .. version or version),
    path = vim.fs.abspath("~/.jdk/java")
      .. version
      .. (jit.os == "OSX" and ("/Library/Java/JavaVirtualMachines/zulu-" .. version .. ".jdk/Contents/Home") or ""),
  }
end

local function create_runtimes(versions)
  local runtimes = {}
  for _, version in ipairs(versions) do
    local runtime = get_openjdk_runtime(version)

    if vim.fn.isdirectory(runtime.path) ~= 0 then
      table.insert(runtimes, runtime)
    end
  end

  return runtimes
end

------- CMD and Args -------

local function get_cache_dir()
  return (os.getenv("XDG_CACHE_HOME") or vim.uv.os_homedir() .. "/.cache") .. "/jdtls"
end

local function get_system_config_file()
  local ext = ({
    Windows = "win",
    Linux = "linux",
    OSX = "mac",
  })[jit.os]

  if ext == nil then
    error("Unknown OS: " .. jit.os)
  end

  return "config_" .. ext
end

local jdtls_path = vim.g.nix.jdtls_path .. "/share/java/jdtls"
local lombok_jar = vim.g.nix.lombok_path .. "/share/java/lombok.jar"

-- Using vim.lsp.config as it has higher priority than files inside lsp/
vim.lsp.config("jdtls", {
  cmd = {
    get_openjdk_runtime(21).path .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-XX:+AlwaysPreTouch",
    "-XX:+UseStringDeduplication",
    "-XX:+UseParallelGC",
    "-XX:GCTimeRatio=4",
    "-XX:AdaptiveSizePolicyWeight=90",
    "-Dsun.zip.disableMemoryMapping=true",
    "-Xmx3G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. lombok_jar,
    "-jar",
    vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-data",
    get_cache_dir() .. "/workspace",
    --"-configuration",
    --jdtls_path .. "/" .. get_system_config_file(),
  },
  filetypes = { "jproperties", "java" },
})

------- Bundles -------
local function get_bundles()
  local bundle_globs = {
    vim.g.nix.vsc_java_debug
      .. "/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar",
    vim.g.nix.vsc_java_test .. "/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar",
    assets_path .. "/bundles/*.jar",
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

  local bundles = {}
  for _, bundle in ipairs(found_bundles) do
    local filename = vim.fn.fnamemodify(bundle, ":t")
    if not vim.tbl_contains(excluded, filename) then
      table.insert(bundles, bundle)
    end
  end
  return bundles
end
------- Actual Config -------

---@type vim.lsp.Config
return {
  init_options = {
    bundles = get_bundles(),
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
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
  filetype = { "java", "jproperties" },
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
        runtimes = create_runtimes({ 8, 17, 21 }),
        updateBuildConfiguration = "automatic",
      },
      contentProvider = { preferred = "fernflower" },
      eclipse = {
        downloadSources = true,
      },
      edit = {
        smartSemicolonDetection = true,
      },
      format = {
        enabled = true,
        settings = {
          url = assets_path .. "jdtls/codestyle.xml",
        },
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
        url = assets_path .. "jdtls/settings.pref",
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
