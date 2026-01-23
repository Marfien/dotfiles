local M = {}

local mason_registry = require("mason-registry")

-- File to store last update timestamp
local update_file = vim.fn.stdpath("data") .. "/mason_last_update"

-- Helper function to read last update time
local function get_last_update_time()
  local file = io.open(update_file, "r")
  if not file then
    return 0
  end
  local timestamp = file:read("*n")
  file:close()
  return timestamp or 0
end

-- Helper function to write current update time
local function write_update_time()
  local file = io.open(update_file, "w")
  if file then
    file:write(os.time())
    file:close()
  end
end

-- Helper function to check if 24 hours have passed since last update
local function should_update()
  local last_update = get_last_update_time()
  local current_time = os.time()
  local one_day = 24 * 60 * 60 -- 24 hours in seconds
  return (current_time - last_update) >= one_day
end

-- Function to install a package if not already installed
--- @return boolean install
local function ensure_installed(package_name)
  local package = mason_registry.get_package(package_name)
  if not package:is_installed() and not package:is_installing() then
    package:install()
    return true
  end

  return false
end

local function install_packages(packages)
  local installed = 0
  for _, package_name in ipairs(packages) do
    if type(package_name) ~= "string" then
      vim.notify("mason-declarative: package name must be a string, got " .. type(package_name), vim.log.levels.WARN)
    else
      if mason_registry.has_package(package_name) then
        if ensure_installed(package_name) then
          installed = installed + 1
        end
      else
        vim.notify("mason-declarative: package '" .. package_name .. "' not found in registry", vim.log.levels.WARN)
      end
    end
  end

  if installed > 0 then
    vim.notify(
      "Successfully installed " .. installed .. (installed == 1 and " package" or " packages"),
      vim.log.levels.INFO
    )
  end
end

-- Function to update all installed packages
local function update_packages()
  vim.notify("Updating mason packages", vim.log.levels.INFO)

  local installed_packages = mason_registry.get_installed_packages()
  if #installed_packages == 0 then
    return
  end

  local updated = 0

  for _, package in ipairs(installed_packages) do
    local latest_version = package:get_latest_version()
    if latest_version ~= package:get_installed_version() then
      package:install({ version = latest_version })
      updated = updated + 1
    end
  end

  write_update_time()
  if updated > 0 then
    vim.notify("Successfully updated " .. updated .. (updated == 1 and " package" or " packages"), vim.log.levels.INFO)
  end
end

-- Main setup function
function M.setup(packages)
  install_packages(packages)

  local co = coroutine.create(function()
    if should_update() then
      update_packages()
    end
  end)
  coroutine.resume(co)
end

return M
