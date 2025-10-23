local M = {}

local function exec_task(self, task, callback)
  local executable = self.project_root .. "/gradlew"
  if jit.os == "Windows" then
    executable = executable .. ".bat"
  end

  vim.system({
    executable,
    self.module_id .. ":" .. task,
  }, {}, callback)
end

---@class util.android.GradleContext
---@field project_root string
---@field module_id string
---@field exec_task fun(task: string, callback: fun(out: vim.SystemCompleted))

---@return util.android.GradleContext
function M.find()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local gradlew = vim.fs.find("gradlew", { upward = true, path = buf_name })[1]
  local project_root = vim.fn.fnamemodify(gradlew, ":h")
  local build_script = vim.fs.find("build.gradle.kts", { upward = true, path = buf_name })[1]
  local module_root = vim.fn.fnamemodify(build_script, ":h")

  local module_id = module_root:sub(#project_root + 1, #module_root):gsub("/", ":")

  return { project_root = project_root, module_id = module_id, exec_task = exec_task }
end

return M
