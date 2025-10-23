local M = {}

local function avd_create_cmd()
  -- Input: Name
  -- Select package
  -- Select Device
end

local function avd_launch_cmd()
  -- Select: avd
  -- emulator @<name>
end

local function avd_delete_cmd()
  -- select: avd
  -- avdmanager delete avd -n <name>
end

local function avd_help()
  vim.notify("Usage: Android avd <create|launch|delete>", vim.log.levels.ERROR)
end

local function avd_cmd(args)
  local sub_cmds = {
    ["create"] = avd_create_cmd,
    ["launch"] = avd_launch_cmd,
    ["delete"] = avd_delete_cmd,
    ["*"] = avd_help,
  }
  (sub_cmds[args[2]] or sub_cmds["*"])()
end

local function install_cmd()
  -- Select running device
  -- Gradle: assembleDebug
  -- adb -s <device-id> install <apk>
  -- adb -s <device-id> shell am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -n <main-activity>
end

local function uninstall_cmd()
  -- select device
  -- adb -s <device-id> uninstall <app_id>
end

local function logcat_cmd()
  -- select device
  -- adb shell logcat
end

local function help()
  vim.notify("Usage: Android <avd|install|uninstall|logcat> [...]", vim.log.levels.ERROR)
end

function M.register()
  vim.api.nvim_create_user_command("Android", function(args)
    local fargs = args.fargs

    if #fargs < 1 then
      help()
      return
    end

    local sub_cmds = {
      ["avd"] = avd_cmd,
      ["install"] = install_cmd,
      ["uninstall"] = uninstall_cmd,
      ["logcat"] = logcat_cmd,
      ["*"] = help,
    }
    (sub_cmds[fargs[1]] or sub_cmds["*"])(fargs)
  end, {
    nargs = "?",
  })
end

return M
