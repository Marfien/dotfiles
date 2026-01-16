local paths = require("util.paths")

local cached_count = 0

vim.api.nvim_create_autocmd({ "BufNew", "BufAdd", "BufDelete", "VimEnter" }, {
  callback = vim.schedule_wrap(function()
    cached_count = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buflisted then
        cached_count = cached_count + 1
      end
    end
  end),
})

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    --{ "AndreM222/copilot-lualine" },
    { "nvim-tree/nvim-web-devicons" },
    { "folke/noice.nvim" },
  },
  init = function()
    vim.opt.laststatus = 3
  end,
  opts = {
    globalstatus = true,
    options = {
      section_separators = "",
      component_separators = { left = "│", right = "│" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        function()
          return "󱉭 " .. vim.fs.basename(paths.project_root())
        end,
        { "branch" },
      },
      lualine_c = {
        {
          function()
            local res = paths.pretty_path(paths.project_root())
            if #res > 0 and cached_count > 1 then
              res = res .. " / " .. cached_count
            end
            return res
          end,
          color = function()
            local bufname = vim.api.nvim_buf_get_name(0)
            local new = vim.fn.filereadable(bufname) == 0 and vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg
              or nil
            local modified = vim.bo.modified and vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg or nil
            local fg = modified or new or vim.api.nvim_get_hl(0, { name = "Normal" }).fg
            return { fg = string.format("#%06X", fg) }
          end,
        },
      },
      lualine_x = {
        { "lsp_status" },
        --{ "copilot" },
        {
          require("noice").api.status.mode.get,
          cond = require("noice").api.status.mode.has,
          color = { fg = "#ff9e64" },
        },
      },
      lualine_y = {
        {
          "fileformat",
          icrons_enabled = true,
          symbols = {
            unix = "LF",
            dos = "CRLF",
            mac = "CR",
          },
        },
        {
          "encoding",
          icons_enabled = true,
        },
      },
      lualine_z = {
        { "location" },
        { "selectioncount" },
      },
    },
  },
}
