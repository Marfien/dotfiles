local M = {}

M.key = "lsp_info"

local symbols = {
  -- Use standard unicode characters for the spinner and done symbols:
  loading = "",
  done = '✓',
  separator = ' ',
}

local lsp_states = {}

local state = {
  attached = "",
  working = symbols.loading,
  done = symbols.done,
}

local function get_lsp_states()
  local components = {}

  for client_id, state_icon in pairs(lsp_states) do
    if state_icon ~= nil then
      local client = vim.lsp.get_client_by_id(client_id)
      if client and client.attached_buffers[vim.api.nvim_get_current_buf()] then
        local name = client.name
        table.insert(components, name)
        if #state_icon > 0 then
          table.insert(components, state_icon)
        end
      end
    end
  end

  return vim.fn.join(components, " ")
end

local function update()
  require("features.status-line.draw-cache").update(M.key, get_lsp_states())
end

function M.setup_autocmds(group)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(event)
      local client_id = event.data.client_id
      lsp_states[client_id] = lsp_states[client_id] or state.attached
      update()
    end
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    group = group,
    callback = function(event)
      local client_id = event.data.client_id
      local client = vim.lsp.get_client_by_id(client_id)
      if not client or #client.attached_buffers == 0 then
        lsp_states[client_id] = nil
        update()
      end
    end
  })

  vim.api.nvim_create_autocmd("LspProgress", {
    group = group,
    callback = function(event)
      local progress_kind = event.data.params.value.kind
      local client_id = event.data.client_id

      if progress_kind == "begin" then
        lsp_states[client_id] = state.working
      elseif progress_kind == "end" then
        lsp_states[client_id] = state.done
      end

      update()
    end
  })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = update
  })

  update()
end

return M
