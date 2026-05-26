local modules = {
  "dashboard",
  "session"
}

return {
  setup = function()
    for _, module in ipairs(modules) do
      require("features." .. module)
    end
  end
}
