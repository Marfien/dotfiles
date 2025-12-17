vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) then
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name ~= "" and vim.bo[bufnr].filetype ~= "oil" and vim.fn.filereadable(name) == 0 then
          pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = function()
    if not require("oil.util").get_preview_win() and not vim.wo.previewwindow then
      vim.schedule(require("oil").open_preview)
    end
  end,
})

function _G.get_oil_winbar(buf)
  buf = buf or vim.g.statusline_winid
  local bufnr = vim.api.nvim_win_get_buf(buf)
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
    lazy = vim.fn.argc(-1) == 0,
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
        ["<CR>"] = {
          mode = "n",
          callback = function()
            local line = vim.v.count
            if line > 0 then
              vim.cmd.normal({
                args = { line .. "G" },
                bang = true,
              })
            end

            require("oil").select({}, nil)
          end,
          desc = "Select (Line)",
        },
      },
    },
    keys = {
      {
        "-",
        "<cmd>Oil<cr>",
        desc = "Oil (parent)",
      },
      {
        "_",
        function()
          vim.cmd({ cmd = "Oil", args = { vim.fn.getcwd() } })
        end,
        desc = "Oil (cwd)",
      },
    },
  },
  {
    "benomahony/oil-git.nvim",
    ft = "oil",
    dependencies = { "stevearc/oil.nvim" },
    opts = {},
  },
}
