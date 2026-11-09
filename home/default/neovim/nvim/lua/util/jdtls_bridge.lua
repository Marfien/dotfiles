--- Glue between jdtls and language servers that delegate to jdtls bundles (lsp4mp, later qute).
---
--- Mirrors what vscode-java/vscode-microprofile do:
---   * server -> client requests of the delegating LS are forwarded to jdtls as
---     `workspace/executeCommand` (`java.execute.workspaceCommand` in VS Code),
---     waiting for jdtls to reach `ServiceReady` first.
---   * jdtls `workspace/executeClientCommand` requests (e.g. `microprofile/propertiesChanged`)
---     are forwarded as notifications to the delegating LS.
---   * `*.command.configuration.update` client commands are applied to the client settings
---     for the lifetime of the Neovim session.
local M = {}

local protocol = vim.lsp.protocol
local READY_EVENT = "JdtlsServiceReady"

--- How long to wait for jdtls to become ready before trying the request anyway.
M.ready_timeout_ms = 120000

---@type table<integer, true> jdtls client ids which reported `ServiceReady`
local ready = {}

---@type table<string, string> jdtls client command -> name of the client to notify
local forwarded_notifications = {}

---@type table<string, table> client name -> settings modified in this session
local session_settings = {}

local function rpc_error(code, message, data)
  if not protocol.ErrorCodes[code] then
    code = protocol.ErrorCodes.RequestFailed
  end
  return vim.lsp.rpc_response_error(code, message, data)
end

---@param root? string
---@return vim.lsp.Client?
local function find_jdtls(root)
  local clients = vim.lsp.get_clients({ name = "jdtls" })
  for _, client in ipairs(clients) do
    if root and client.root_dir == root then
      return client
    end
  end
  return clients[1]
end

---@param root? string
local function is_ready(root)
  local client = find_jdtls(root)
  return client ~= nil and ready[client.id] == true
end

--- Suspends the running coroutine until jdtls is ready or the timeout is hit.
---@param root? string
---@return vim.lsp.Client?
local function await_jdtls(root)
  local co = coroutine.running()
  if is_ready(root) or not co then
    return find_jdtls(root)
  end

  local done = false
  local autocmd, timer
  local function finish()
    if done then
      return
    end
    done = true
    pcall(vim.api.nvim_del_autocmd, autocmd)
    timer:stop()
    timer:close()
    vim.schedule(function()
      coroutine.resume(co)
    end)
  end

  autocmd = vim.api.nvim_create_autocmd("User", {
    pattern = READY_EVENT,
    callback = function()
      if is_ready(root) then
        finish()
      end
    end,
  })
  timer = assert(vim.uv.new_timer())
  timer:start(M.ready_timeout_ms, 0, vim.schedule_wrap(finish))

  coroutine.yield()
  return find_jdtls(root)
end

--- Executes a command contributed by a jdtls bundle.
--- Must be called from within a coroutine (server request handlers are) to not block.
---@param command string
---@param params any
---@param root? string root dir used to pick the matching jdtls client
---@return any result, lsp.ResponseError? err
function M.execute(command, params, root)
  local client = await_jdtls(root)
  if not client then
    return nil, rpc_error(protocol.ErrorCodes.RequestFailed, "jdtls is not running")
  end

  local request = { command = command, arguments = { params } }
  local co = coroutine.running()

  ---@type { err: lsp.ResponseError?, result: any }?
  local response
  local sent = client:request("workspace/executeCommand", request, function(err, result)
    response = { err = err, result = result }
    if co and coroutine.status(co) == "suspended" then
      coroutine.resume(co)
    end
  end)

  if not sent then
    return nil, rpc_error(protocol.ErrorCodes.RequestFailed, "Failed to send request to jdtls")
  end

  if not response then
    if co then
      coroutine.yield()
    else
      vim.wait(10000, function()
        return response ~= nil
      end)
    end
  end

  if not response then
    return nil, rpc_error(protocol.ErrorCodes.RequestFailed, "jdtls did not respond to " .. command)
  end
  if response.err then
    return nil, rpc_error(response.err.code, response.err.message, response.err.data)
  end
  if response.result == nil then
    return vim.NIL
  end
  return response.result
end

--- Creates `handlers` that forward the given server requests to jdtls.
---@param methods string[]
---@return table<string, lsp.Handler>
function M.forward_requests(methods)
  local handlers = {}
  for _, method in ipairs(methods) do
    handlers[method] = function(_, params, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      return M.execute(method, params, client and client.root_dir)
    end
  end
  return handlers
end

--- Forwards the jdtls client command `command` as notification to all clients named `client_name`.
---@param command string
---@param client_name string
function M.forward_notification(command, client_name)
  forwarded_notifications[command] = client_name
end

--- Handlers to add to the jdtls config.
---@return table<string, lsp.Handler>
function M.jdtls_handlers()
  return {
    ["language/status"] = function(err, result, ctx, config)
      if result and result.type == "ServiceReady" then
        ready[ctx.client_id] = true
        vim.api.nvim_exec_autocmds("User", { pattern = READY_EVENT, data = { client_id = ctx.client_id } })
      end

      local fallback = vim.lsp.handlers[ctx.method]
      if fallback then
        return fallback(err, result, ctx, config)
      end
    end,

    ["workspace/executeClientCommand"] = function(err, params, ctx, config)
      local target = forwarded_notifications[params.command]
      if target then
        for _, client in ipairs(vim.lsp.get_clients({ name = target })) do
          client:notify(params.command, (params.arguments or {})[1])
        end
        return vim.NIL
      end

      local fallback = vim.lsp.handlers[ctx.method]
      if fallback then
        return fallback(err, params, ctx, config)
      end

      local command = vim.lsp.commands[params.command]
      if command then
        command({ title = params.command, command = params.command, arguments = params.arguments }, ctx)
        return vim.NIL
      end

      return nil, rpc_error(protocol.ErrorCodes.MethodNotFound, "Unknown client command: " .. params.command)
    end,
  }
end

------- Session settings -------

---@enum util.jdtls_bridge.EditType
local EditType = { Add = 0, Delete = 1, Update = 2, Remove = 3 }

---@param list any[]
---@param values any
---@param remove boolean
local function edit_list(list, values, remove)
  values = vim.islist(values) and values or { values }
  for _, value in ipairs(values) do
    local index = vim.iter(ipairs(list)):find(function(_, item)
      return vim.deep_equal(item, value)
    end)
    if remove and index then
      table.remove(list, index)
    elseif not remove and not index then
      table.insert(list, value)
    end
  end
  return list
end

--- Applies a `ConfigurationItemEdit` (`{ section, value, editType, scopeUri }`) to the client
--- settings, remembers it for restarts within this session and notifies the server.
---@param client vim.lsp.Client
---@param edit { section: string, value: any, editType: integer }
function M.apply_configuration_edit(client, edit)
  local keys = vim.split(edit.section, ".", { plain = true })
  local last = table.remove(keys)

  local parent = client.settings
  for _, key in ipairs(keys) do
    parent[key] = type(parent[key]) == "table" and parent[key] or {}
    parent = parent[key]
  end

  if edit.editType == EditType.Add then
    parent[last] = edit_list(parent[last] or {}, edit.value, false)
  elseif edit.editType == EditType.Remove then
    parent[last] = edit_list(parent[last] or {}, edit.value, true)
  elseif edit.editType == EditType.Update then
    parent[last] = edit.value
  elseif edit.editType == EditType.Delete then
    parent[last] = nil
  end

  session_settings[client.name] = vim.deepcopy(client.settings)
  client:notify("workspace/didChangeConfiguration", { settings = client.settings })
  vim.notify(("[%s] %s updated (until Neovim exits)"):format(client.name, edit.section), vim.log.levels.INFO)
end

--- Restores settings changed in this session. Use in `before_init`.
---@param config vim.lsp.ClientConfig
function M.restore_session_settings(config)
  local settings = session_settings[config.name]
  if not settings then
    return
  end
  -- client.settings references config.settings, so it has to be modified in place
  for key in pairs(config.settings) do
    config.settings[key] = nil
  end
  for key, value in pairs(vim.deepcopy(settings)) do
    config.settings[key] = value
  end
end

--- Opens the URI passed by `*.command.open.uri` client commands.
---@param uri string
function M.open_uri(uri)
  if uri:match("^https?://") then
    vim.ui.open(uri)
  elseif uri:match("^file://") then
    vim.cmd.edit(vim.fn.fnameescape(vim.uri_to_fname(uri)))
  else
    -- e.g. jdt:// handled by nvim-jdtls
    vim.cmd.edit(vim.fn.fnameescape(uri))
  end
end

return M
