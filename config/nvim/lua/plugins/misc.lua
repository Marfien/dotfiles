return {
  {
    "Marfien/simple-pairs.nvim",
    branch = "feat/advanced-config",
    event = "InsertEnter",
    opts = {},
  },
  {
    "nvim-mini/mini.bufremove",
    version = false,
    opts = {
      silent = true,
    },
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete()
        end,
        desc = "Delete",
      },
      {
        "<leader>bo",
        function()
          local delete = require("mini.bufremove").delete

          for _, buf in vim.api.nvim_list_bufs() do
            if vim.bo[buf].buflisted and not buf == vim.api.nvim_get_current_buf() then
              delete(buf)
            end
          end
        end,
        desc = "Delete Other",
      },
      {
        "<leader>bD",
        function()
          local delete = require("mini.bufremove").delete

          for _, buf in vim.api.nvim_list_bufs() do
            delete(buf)
          end
        end,
        desc = "Delete All",
      },
    },
  },
  {
    "chrishrb/gx.nvim",
    cmd = "Browse",
    keys = {
      { "gx", "<cmd>Browse<cr>", mode = { "n", "x" }, desc = "Open in Browser" },
    },
    init = function()
      vim.g.netrw_nogx = 1
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    submodules = false,
    opts = function(opts)
      opts = opts or {}

      if vim.env.WSL_DISTRO_NAME ~= nil then
        opts.open_browser_app = "powershell.exe"
        opts.open_browser_args = { "start", "explorer.exe" }
      end

      return opts
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "BufEnter",
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
  },
  {
    "nvim-mini/mini.jump",
    version = "*",
    event = "BufEnter",
    opts = {
      silent = true,
      delay = {
        highlight = math.pow(2, 16),
      },
    },
  },
}
