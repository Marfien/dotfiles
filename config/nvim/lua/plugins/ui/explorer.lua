-- TODO: delte buffers that are invalid
-- vim.api.nvim_create_autocmd("BufHidden", {
--   callback = function(event)
--     if vim.bo[event.buf].filetype == "oil" then
--       for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--         local file_name = vim.api.nvim_buf_get_name(buf)
--         if file_name and file_name ~= "" and vim.fn.filereadable(file_name) == 0 then
--           --require("util.buffers").delete({ buf = buf })
--           print("Would delete (" .. buf .. ") " .. file_name)
--         end
--       end
--     end
--   end,
-- })

function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      { "nvim-tree/nvim-web-devicons", opts = {} },
    },
    opts = {
      columns = {
        "size",
        "icon",
      },
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == ".git" or name == ".."
        end,
      },
      win_options = {
        winbar = "%!v:lua.get_oil_winbar()",
        relativenumber = false,
        colorcolumn = "",
      },
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
        ["ESC"] = { "actions.close", mode = "n" },
      },
    },
    keys = {
      {
        "-",
        function()
          require("oil").open(nil, { preview = { vertical = true, split = "botright" } })
        end,
        desc = "Oil",
      },
    },
  },
  {
    "benomahony/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = {},
  },
  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = {},
  },
}
