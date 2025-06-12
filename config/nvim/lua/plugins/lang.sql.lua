return {
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      require("dbee").install()
    end,
    -- dbee.sources module is not avaliable yet.
    opts = function()
      return {
        sources = {
          require("dbee.sources").EnvSource:new("DBEE_CONNTECTIONS"),
          require("dbee.sources").FileSource:new(vim.fn.getcwd() .. "/.dbee/connections.json"),
          vim.env.DBEE_CONNECTIONS_PATH and require("dbee.sources").FileSource:new(vim.env.DBEE_CONNECTIONS_PATH)
            or nil,
        },
      }
    end,
  },
}
