return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          exclude = { ".git" },
          actions = {
            confirm_recurivly = function(picker, item)
              local actions = require("snacks.explorer.actions")
              local tree = require("snacks.explorer.tree")

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
                tree:toggle(node.path)
                actions.update(picker, { refresh = true })
                vim.schedule(function()
                  local child = might_get_child(node)

                  if not child or not child.dir then
                    return
                  end

                  open_recursive(child)
                end)
              end

              local node = tree:node(item.file)

              if not node then
                return
              end

              if node.dir then
                open_recursive(node)
              else
                picker:action("confirm")
              end
            end,
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
