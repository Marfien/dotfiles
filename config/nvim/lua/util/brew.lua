local M = {}

M._brew_path = nil

local function calc_brew_path()
  local brew_handle = io.popen("brew --prefix")
  if not brew_handle then
    error("Brew Path could not be determined")
  end

  local brew_path = brew_handle:read("*a"):gsub("\n", "")
  brew_handle:close()

  -- throw error when brewPath nil
  if not brew_path then
    vim.notify("Brew Path cannot be found. Disabling nvim-jdtls...")
    return false
  end

  return brew_path
end

function M.get_brew_path()
  if not M._brew_path then
    M._brew_path = calc_brew_path()
  end

  return M._brew_path
end

return M
