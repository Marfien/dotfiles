vim.g.tex_flavor = "latex"

_G.wsl_texlab_executable = vim.system({
  "powershell.exe",
  "-nologo",
  "-noprofile",
  "-command",
  "wsl wslpath (get-command sioyek).Source.Replace('\\', '\\\\')",
})

local function buf_build(client, bufnr)
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request("textDocument/build", params, function(err, result)
    if err then
      error(tostring(err))
    end
    local texlab_build_status = {
      [0] = "Success",
      [1] = "Error",
      [2] = "Failure",
      [3] = "Cancelled",
    }
    vim.notify("Build " .. texlab_build_status[result.status], vim.log.levels.INFO)
  end, bufnr)
end

local function buf_search(client, bufnr)
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request("textDocument/forwardSearch", params, function(err, result)
    if err then
      error(tostring(err))
    end
    local texlab_forward_status = {
      [0] = "Success",
      [1] = "Error",
      [2] = "Failure",
      [3] = "Unconfigured",
    }
    vim.notify("Search " .. texlab_forward_status[result.status], vim.log.levels.INFO)
  end, bufnr)
end

local function buf_cancel_build(client, bufnr)
  return client:exec_cmd({
    title = "cancel",
    command = "texlab.cancelBuild",
  }, { bufnr = bufnr })
end

local function dependency_graph(client)
  client:exec_cmd({ command = "texlab.showDependencyGraph" }, { bufnr = 0 }, function(err, result)
    if err then
      return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
    end
    vim.notify("The dependency graph has been generated:\n" .. result, vim.log.levels.INFO)
  end)
end

local function command_factory(cmd)
  local cmd_tbl = {
    Auxiliary = "texlab.cleanAuxiliary",
    Artifacts = "texlab.cleanArtifacts",
  }
  return function(client, bufnr)
    return client:exec_cmd({
      title = ("clean_%s"):format(cmd),
      command = cmd_tbl[cmd],
      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    }, { bufnr = bufnr }, function(err, _)
      if err then
        vim.notify(("Failed to clean %s files: %s"):format(cmd, err.message), vim.log.levels.ERROR)
      else
        vim.notify(("Command %s executed successfully"):format(cmd), vim.log.levels.INFO)
      end
    end)
  end
end

local function clean_all()
  command_factory("Artifacts")()
  command_factory("Auxiliary")()
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("texlab_cmds", {}),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or client.name ~= "texlab" then
      return
    end
    for _, cmd in ipairs({
      { name = "TexlabBuild", fn = buf_build, desc = "Build the current buffer", keymap = "b" },
      { name = "TexlabForward", fn = buf_search, desc = "Forward search from current position", keymap = "f" },
      { name = "TexlabCancelBuild", fn = buf_cancel_build, desc = "Cancel the current build", keymap = "B" },
      { name = "TexlabDependencyGraph", fn = dependency_graph, desc = "Show the dependency graph", keymap = "d" },
      { name = "TexlabCleanArtifacts", fn = command_factory("Artifacts"), desc = "Clean the artifacts", keymap = "ca" },
      {
        name = "TexlabCleanAll",
        fn = clean_all,
        desc = "Clean all files",
        keymap = "cc",
      },
      {
        name = "TexlabCleanAuxiliary",
        fn = command_factory("Auxiliary"),
        desc = "Clean the auxiliary files",
        keymap = "cx",
      },
    }) do
      local cmd_name = "Lsp" .. cmd.name
      local bufnr = event.buf

      vim.api.nvim_buf_create_user_command(bufnr, cmd_name, function()
        cmd.fn(client, bufnr)
      end, { desc = cmd.desc })

      if cmd.keymap ~= nil then
        vim.api.nvim_buf_set_keymap(
          bufnr,
          "n",
          "<localleader>l" .. cmd.keymap,
          "<cmd>" .. cmd_name .. "<cr>",
          { desc = cmd.desc }
        )
      end
    end
  end,
})

return require("util.lsp").ensure_lang({
  parsers = { "bibtex", "latex" }, -- latex parser needs tree-sitter cli
  ft = { "tex", "bib", "plaintex" },
  formatters = { "tex-fmt" },
  tools = { "tex-fmt", "texlab" },
  other = {
    {
      "stevearc/conform.nvim",
      opts = {
        formatters = {
          ["tex-fmt"] = {
            args = { "--wraplen", "120", "--stdin" },
          },
        },
      },
    },
  },
})
