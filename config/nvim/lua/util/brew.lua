local M = {}

M._brew_path = nil

local function calc_brew_path()
  local syscall = vim.system({ "brew", "--prefix" }):wait()
  if syscall.code ~= 0 then
    error("Failed to get brew path: " .. syscall.stderr)
  end

  return syscall.stdout:gsub("\n", "")
end

function M.get_brew_path()
  if not M._brew_path then
    M._brew_path = calc_brew_path()
  end

  return M._brew_path
end

return M
