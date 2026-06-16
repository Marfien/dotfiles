local modules = {
  "dashboard",
  "session",
  "status-line"
}

return {
  setup = function()
    for _, module in ipairs(modules) do
      require("features." .. module).setup()
    end
  end
}
