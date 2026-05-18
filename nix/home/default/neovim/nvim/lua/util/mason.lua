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
--- @return table? version_info
local function ensure_installed(package_name, version)
  local success, package = pcall(mason_registry.get_package, package_name)
  if not success then
    vim.notify("Package not found: " .. package_name, vim.log.levels.ERROR)
    return nil
  end

  local requested_version = version or package:get_latest_version()
  local current_version = package:get_installed_version()

  if not package:is_installing() and current_version ~= requested_version then
    package:install({ version = requested_version })

    return { current = current_version, requested = requested_version }
  else
    return nil
  end
end

local function check_packages(packages)
  local upgrade = {}
  for _, package_handle in ipairs(packages) do
    if type(package_handle) == "string" then
      local split, _ = package_handle:find("@")
      local name = split and package_handle:sub(0, split - 1) or package_handle
      local version = split and package_handle:sub(split + 1, #package_handle)
      upgrade[name] = ensure_installed(name, version)
    else
      vim.notify("mason-declarative: package name must be a string, got " .. type(package_handle), vim.log.levels.WARN)
    end
  end

  local upgrade_str = ""
  for name, version_info in pairs(upgrade) do
    if version_info then
      upgrade_str = upgrade_str
        .. "\n  "
        .. name
        .. ": "
        .. (version_info.current or "-/-")
        .. " -> "
        .. version_info.requested
    end
  end

  if #upgrade_str > 0 then
    vim.notify("Requested Upgrades:" .. upgrade_str, vim.log.levels.INFO)
  end
end

-- Main setup function
function M.setup(packages)
  if should_update() then
    write_update_time()
    mason_registry.update(function()
      vim.notify("Checking Mason for updates...")
      check_packages(packages)
    end)
  end
end

function M.performUpdate(packages)
  mason_registry.update(function()
    vim.notify("Checking Mason for updates...")
    check_packages(packages)
  end)
end

return M
