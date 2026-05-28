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

  for client, state_icon in pairs(lsp_states) do
    local name = vim.lsp.get_client_by_id(client).name
    table.insert(components, name)
    table.insert(components, state_icon)
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
      lsp_states[client_id] = state.attached
      update()
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

  update()
end

return M
