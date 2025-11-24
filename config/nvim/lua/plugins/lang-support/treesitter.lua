return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
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
      },
    },
    config = function(_, opts)
      local wanted_parsers = opts.ensure_installed
      opts.ensure_installed = nil

      require("nvim-treesitter").install(wanted_parsers, { summary = true })

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
    keys = {
      {
        "af",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
        end,
        desc = "Outer function",
        mode = { "x", "o" },
      },
      {
        "if",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
        end,
        desc = "Inner function",
        mode = { "x", "o" },
      },
      {
        "ac",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
        end,
        desc = "Outer class",
        mode = { "x", "o" },
      },
      {
        "ip",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@variable.parameter.inner", "textobjects")
        end,
        desc = "Inner class",
        mode = { "x", "o" },
      },
      {
        "ap",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@variable.parameter.outer", "textobjects")
        end,
        desc = "Inner class",
        mode = { "x", "o" },
      },
      {
        "ic",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
        end,
        desc = "Inner class",
        mode = { "x", "o" },
      },
      {
        "as",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "textobjects")
        end,
        desc = "Local Scope",
        mode = { "x", "o" },
      },
      {
        "]f",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next Function Start",
      },
      {
        "]F",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next Function End",
      },
      {
        "[f",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev. Function Start",
      },
      {
        "[F",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev. Function End",
      },
      {
        "]k",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next Class Start",
      },
      {
        "]K",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next Class End",
      },
      {
        "[k",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev. Class Start",
      },
      {
        "[K",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev. Class End",
      },
    },
  },
}
