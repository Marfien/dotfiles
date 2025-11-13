require("util.pairs").setup({})

return {
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
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
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

      if vim.env.WSL_DISTRO_NAME then
        opts.open_browser_app = vim.env.WSL_DISTRO_NAME and "powershell.exe" or "os_specific"
        opts.open_browser_args = { "start", "explorer.exe" }
      end

      return opts
    end,
  },
  {
    "retran/meow.yarn.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("meow.yarn").setup({})
    end,
    keys = {
      { "<leader>cS", "<Cmd>MeowYarn call callers<CR>", desc = "Call Stack", mode = { "n", "x" } },
    },
  },
}
