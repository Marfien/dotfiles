-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- disable line wrap, spell is always active
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

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

      vim.notify("Activated virtual environment: " .. venv_dir)
    end
  end,
})
