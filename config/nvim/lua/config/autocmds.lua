-- Python virtual env
local function find_venv()
  local dir_names = { ".venv", "venv" }
  local cwd = vim.fn.getcwd()

  for _, dir in ipairs(dir_names) do
    local possible_venv = cwd .. "/" .. dir

    if vim.fn.isdirectory(possible_venv) then
      return possible_venv
    end
  end

  return nil
end

vim.api.nvim_create_autocmd({ "DirChanged" }, {
  group = vim.api.nvim_create_augroup("venv_detect", {}),
  pattern = "global",
  callback = function()
    local venv_dir = find_venv()

    if venv_dir ~= nil then
      vim.env.VIRTUAL_ENV = venv_dir
      vim.env.PATH = venv_dir .. "/bin:" .. vim.env.PATH

      vim.notify("Activated virtual environment: \n" .. venv_dir)
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})
