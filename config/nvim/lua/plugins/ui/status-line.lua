---@module 'util.paths'
local paths = nil
local cached_count = 0
local status_message = ""

local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("status-line", {})
  vim.api.nvim_create_autocmd({ "BufNew", "BufAdd", "BufDelete", "VimEnter" }, {
    group = group,
    callback = vim.schedule_wrap(function()
      cached_count = 0
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted then
          cached_count = cached_count + 1
        end
      end
    end),
  })

  vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
    group = group,
    callback = function(ev)
      status_message = ev.event == "RecordingEnter" and "@" .. vim.fn.reg_recording() or ""
    end,
  })
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  config = function(_, opts)
    paths = require("util.paths")
    vim.opt.laststatus = 3

    require("lualine").setup(opts)
    setup_autocmds()
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
            return cached_count
          end,
          cond = function()
            return cached_count > 1
          end,
        },
        {
          function()
            return paths.pretty_path(paths.project_root())
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
        -- stylua: ignore
        {
          function() return status_message end,
          cond = function() return #status_message > 0 end,
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
