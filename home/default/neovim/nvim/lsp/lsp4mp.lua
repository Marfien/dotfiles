-- MicroProfile/Quarkus language server, ported from redhat.vscode-microprofile + redhat.vscode-quarkus.
-- Java (bundles) side lives in lsp/jdtls.lua.
local bridge = require("util.jdtls_bridge")

local microprofile_ext = vim.g.nix.vsc_microprofile
local quarkus_ext = vim.g.nix.vsc_quarkus

------- Activation -------

-- Same heuristic as vscode-quarkus' isQuarkusProject(), extended to plain MicroProfile projects
local build_files = { "pom.xml", "build.gradle", "build.gradle.kts" }
local markers = { "io.quarkus", "org.eclipse.microprofile" }

local function uses_microprofile(file)
  local fd = io.open(file, "r")
  if not fd then
    return false
  end
  local content = fd:read("*a")
  fd:close()

  return vim.iter(markers):any(function(marker)
    return content:find(marker, 1, true) ~= nil
  end)
end

---@param bufnr integer
---@param on_dir fun(root_dir?: string)
local function root_dir(bufnr, on_dir)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  -- skip unnamed and non-file buffers (e.g. jdt://)
  if fname == "" or fname:match("^%a[%w+.-]*://") then
    return
  end

  local root = vim.fs.root(bufnr, { ".git", "gradlew", "mvnw" })
  local found = vim.fs.find(build_files, {
    upward = true,
    path = vim.fs.dirname(fname),
    stop = root and vim.fs.dirname(root) or nil,
    limit = math.huge,
  })
  -- gradle version catalog
  local catalog = root and root .. "/gradle/libs.versions.toml"
  if catalog and vim.uv.fs_stat(catalog) then
    table.insert(found, catalog)
  end

  if vim.iter(found):any(uses_microprofile) then
    -- the furthest build file is the (multi-module) project root
    on_dir(root or vim.fs.dirname(found[#found]))
  end
end

------- Requests delegated to jdtls -------

bridge.forward_notification("microprofile/propertiesChanged", "lsp4mp")

local handlers = bridge.forward_requests({
  "microprofile/projectInfo",
  "microprofile/propertyDefinition",
  "microprofile/propertyDocumentation",
  "microprofile/jsonSchemaForProjectInfo",
  "microprofile/java/codeAction",
  "microprofile/java/codeActionResolve",
  "microprofile/java/codeLens",
  "microprofile/java/completion",
  "microprofile/java/definition",
  "microprofile/java/diagnostics",
  "microprofile/java/hover",
  "microprofile/java/inlayHint",
  "microprofile/java/workspaceSymbols",
  "microprofile/java/fileInfo",
  "microprofile/java/projectLabels",
  "microprofile/java/workspaceLabels",
})

---@type vim.lsp.Config
return {
  -- stylua: ignore
  cmd = {
    "java",
    "-Xmx64M", "-XX:+UseG1GC", "-XX:+UseStringDeduplication", "-Xlog:disable",
    "-cp", microprofile_ext .. "/server/*:" .. quarkus_ext .. "/server/com.redhat.quarkus.ls.jar",
    "org.eclipse.lsp4mp.ls.MicroProfileServerLauncher",
  },
  filetypes = { "jproperties", "java" },
  root_dir = root_dir,
  settings = {
    microprofile = {
      tools = {
        formatting = { surroundEqualsWithSpaces = false },
        symbols = { showAsTree = true },
        validation = {
          enabled = true,
          duplicate = { severity = "warning" },
          required = { severity = "none" },
          unknown = {
            severity = "warning",
            excluded = { "*/mp-rest/providers/*/priority", "mp.openapi.schema.*", "kafka-streams.*", "camel.*" },
          },
          syntax = { severity = "error" },
          value = { severity = "error" },
          expression = { severity = "error", excluded = {} },
          unassigned = { excluded = {} },
        },
        codeLens = { urlCodeLensEnabled = true },
        inlayHint = {
          enabled = true,
          converters = { enabled = false },
          defaultValues = { enabled = true },
          types = { enabled = false },
          resolveExpressions = { enabled = true },
        },
      },
    },
  },
  init_options = {
    extendedClientCapabilities = {
      commands = {
        commandsKind = {
          valueSet = { "microprofile.command.configuration.update", "microprofile.command.open.uri" },
        },
      },
      completion = { skipSendingJavaCompletionThroughLanguageServer = false },
      shouldLanguageServerExitOnShutdown = true,
    },
  },
  handlers = handlers,
  commands = {
    ["microprofile.command.open.uri"] = function(command)
      bridge.open_uri(command.arguments[1])
    end,
    ["microprofile.command.configuration.update"] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      bridge.apply_configuration_edit(client, command.arguments[1])
    end,
  },
  before_init = function(params, config)
    bridge.restore_session_settings(config)
    -- wrapped with key 'settings' so it is handled the same as didChangeConfiguration
    params.initializationOptions.settings = config.settings
  end,
}
