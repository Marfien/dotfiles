local assets_path = vim.fn.stdpath("config") .. "/assets/lsp4mp"

local function createHandler(handler)
  ---@param ctx lsp.HandlerContext
  return function(_, params, ctx)
    local jdtls = vim.lsp.get_clients({ name = "jdtls" })[1]
    local requestParams = {
      command = handler,
      arguments = params,
    }

    if jdtls == nil then
      -- Return empty response for now
      return {}, nil
    end

    local res = jdtls:request_sync("workspace/executeCommand", requestParams, 1000, ctx.bufnr)
    if res == nil then
      return nil, vim.lsp.rpc_response_error(vim.lsp.protocol.ErrorCodes.RequestFailed, "RequestFailed")
    end

    if type(res) == "string" then
      return nil, vim.lsp.rpc_response_error(vim.lsp.protocol.ErrorCodes.RequestFailed, "Error from lsp", res)
    end

    return res.result, res.err
  end
end

local handlerMethods = {
  "microprofile/projectInfo",
  "microprofile/propertyDefinition",
  "microprofile/propertyDocumentation",
  "microprofile/jsonSchemaForProjectInfo",
  "microprofile/java/codeActionResolve",
  "microprofile/java/codeAction",
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
  "microprofile/propertiesChanged",
}

local handlers = {}

for _, method in ipairs(handlerMethods) do
  handlers[method] = createHandler(method)
end

---@type vim.lsp.Config
return {
  cmd = {
    "java",
    "-jar",
    vim.fn.glob(assets_path .. "/*.jar"),
    "--classpath",
    assets_path .. "/classpath/",
  },
  filetypes = { "jproperties", "java" },
  root_markers = { ".git", "gradlew", "mvnw" },
  handlers = handlers,
  on_attach = function(lsp4mp_client, buf)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp4mp_jdts", {}),
      buffer = buf,
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == "jdtls" then
          lsp4mp_client:notify("workspace/didChangeWatchedFiles", {
            changes = {
              {
                uri = vim.api.nvim_buf_get_name(buf),
                type = 2,
              },
            },
          })
        end
      end,
    })
  end,
}
