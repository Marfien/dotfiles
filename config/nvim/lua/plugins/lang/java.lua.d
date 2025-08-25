-- TODO: copy defaults from lazy vim
local brewHandle = io.popen("brew --prefix")
if not brewHandle then
  error("Brew Path could not be determined")
end

local brewPath = brewHandle:read("*a")
brewHandle:close()

-- throw error when brewPath nil
if not brewPath then
  vim.notify("Brew Path cannot be found. Disabling nvim-jdtls...")
  return {
    "mfussenegger/nvim-jdtls",
    enabled = false,
  }
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "java" } },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote (127.0.0.1)",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }
    end,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = { ensure_installed = { "java-debug-adapter", "java-test" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        jdtls = {},
      },
      setup = {
        jdtls = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      -- settings is passed directly to jdtls
      settings = {
        java = {
          contentProvider = { preferred = "fernflower" },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            hashCodeEquals = {
              useJava7Objects = true,
            },
            useBlocks = true,
          },
          cleanup = {
            actionsOnSave = { "qualifyStaticMembers", "qualifyMembers", "addOverride" },
          },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            -- Filter jdk internal classes
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
          },
          saveActions = {
            organizeImports = true,
          },
          -- maven = {
          --   downloadSources = true,
          -- },
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            runtimes = {
              {
                name = "JavaSE-1.8",
                path = brewPath .. "/opt/openjdk@8",
              },
              {
                name = "JavaSE-17",
                path = brewPath .. "/opt/openjdk@17",
              },
              {
                name = "JavaSE-21",
                path = brewPath .. "/opt/openjdk@21",
              },
            },
            updateBuildConfiguration = "automatic",
          },
        },
      },
    },
  },
}
