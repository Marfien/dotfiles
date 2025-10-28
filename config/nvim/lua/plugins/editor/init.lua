return {
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    version = false,
    opts = {
      mappings = {
        -- Do not add quote after quote
        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = '[^\\"].', register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^\\'].", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },

        [">"] = { action = "close", pair = "<>" },
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
  {
    "nvim-mini/mini.indentscope",
    version = "*",
    event = "BufEnter",
    opts = {
      -- disable mappings as they are handled by nvim-various-textobjs
      mappings = {
        object_scope = "",
        object_scope_with_border = "",
        goto_top = "",
        goto_bottom = "",
      },
      draw = {
        animation = function()
          return 0
        end,
      },
      symbol = "▏",
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
