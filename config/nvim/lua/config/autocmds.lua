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
  pattern = { "global" },
  callback = function()
    local venv_dir = find_venv()

    if venv_dir ~= nil then
      vim.env.VIRTUAL_ENV = venv_dir
      vim.env.PATH = venv_dir .. "/bin:" .. vim.env.PATH

      vim.notify("Activated virtual environment: \n" .. venv_dir)
    end
  end,
})
