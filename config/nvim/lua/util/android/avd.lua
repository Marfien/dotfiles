local M = {}

local emulator = vim.env.ANDROID_HOME .. "/emulator/emulator"

---@param name string
---@return boolean success
function M.launch(name)
  local data = vim
    .system({
      emulator,
      "-avd",
      name,
    })
    :wait()

  return data.code == 0
end

---@return string[] | boolean
function M.list()
  local data = vim
    .system({
      emulator,
      "-list-avds",
    })
    :wait()

  return data.code == 0 and vim.fn.split(data.stdout, "\n", false) or false
end

---@param name string
---@return boolean success
function M.delete(name)
  local data = vim
    .system({
      "avdmanager",
      "delete",
      "avd",
      "--name",
      "name",
    })
    :wait()

  return data.code == 0
end

function M.create(name, image, device)
  local data = vim
    .system({
      "sdkmanager",
      image,
    })
    :wait()

  if data.code ~= 0 then
    -- TODO: error messages
    return false
  end

  data = vim
    .system({
      "avdmanager",
      "create",
      "avd",
      "--name",
      name,
      "--package",
      image,
      "--device",
      device,
    })
    :wait()

  -- TODO: error messages

  return data.code == 0
end

function M.list_images()
  local data = vim
    .system({
      "sdkmanager",
      "--list",
    })
    :wait()

  if data.code ~= 0 then
    return false
  end

  local lines = vim.fn.split(data.stdout, "\n")
  local packages = {}
  for _, line in pairs(lines) do
    local parts = vim.fn.split(line, nil, false)
    local possible_pkg = parts[1]
    if vim.startswith(possible_pkg, "system-images") then
      table.insert(packages, possible_pkg)
    end
  end

  return vim.fn.uniq(packages)
end

return M
