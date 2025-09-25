return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = function()
      require("nvim-treesitter").update()
    end,
    opts_extend = {
      "ensure_installed",
    },
    opts = {
      ensure_installed = {
        "css",
        "ruby",
        "csv",
        "dockerfile",
        "editorconfig",
        "git_config",
        "helm",
        "html",
        "http",
        "jq",
        "pug",
        "sql",
        "json",
      },
    },
    config = function(_, opts)
      local wanted_parsers = opts.ensure_installed
      opts.ensure_installed = nil

      local treesitter = require("nvim-treesitter")
      require("nvim-treesitter.install").install()
      treesitter.setup()
      treesitter.install(wanted_parsers, { summary = true })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        group = vim.api.nvim_create_augroup("ts_features", {}),
        callback = function()
          local successful = pcall(vim.treesitter.start)
          if successful then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      select = {
        lookahead = false,
      },
    },
    -- TODO: keymap
  },
}
