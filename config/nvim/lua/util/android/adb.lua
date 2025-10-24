local M = {}

---Installs the apk on the given device
---@param device string
---@param apk string path to the apk
---@return boolean successful
function M.install(device, apk) end

---Runs the application on device
---@param device string
---@param main_activity? string
---@return boolean successful
function M.run(device, main_activity) end

---Removes the binary from the device
---@param device string
---@param application_id string
---@return boolean successful
function M.uninstall(device, application_id) end

---Returns a stream of log messages from the device
---@param device string
---@return string logcat
function M.logcat(device) end

return M
