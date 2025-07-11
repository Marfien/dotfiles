local Actions = require("snacks.explorer.actions")
local Tree = require("snacks.explorer.tree")

local confirm_recursivly = function(picker, item)
  local might_get_child = function(node)
    local child = nil
    for _, node_child in pairs(node.children) do
      if child then
        return nil
      end
      child = node_child
    end

    return child
  end

  local function open_recursive(node)
    Tree:toggle(node.path)
    Actions.update(picker, { refresh = true })
    vim.schedule(function()
      local child = might_get_child(node)

      if not child or not child.dir then
        return
      end

      open_recursive(child)
    end)
  end

  local node = Tree:node(item.file)

  if not node then
    return
  end

  if node.dir then
    open_recursive(node)
  else
    picker:action("confirm")
  end
end

return {
  "folke/snacks.nvim",
  opts = {
    scroll = { enabled = false },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          exclude = { ".git" },
          actions = {
            confirm_recurivly = confirm_recursivly,
          },
          win = {
            list = {
              keys = {
                ["<CR>"] = { "confirm_recurivly", mode = { "n", "i" } },
              },
            },
          },
        },
        grep = {
          hidden = true,
          ignored = true,
          exclude = {
            "^import.*",
          },
        },
        files = {
          hidden = true,
          ignored = true,
          exclude = { ".git", "*.class" },
        },
      },
    },
  },
}
