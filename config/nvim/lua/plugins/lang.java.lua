local brewHandle = io.popen("brew --prefix")
if not brewHandle then
  error("Brew Path could not be determined")
end

local brewPath = brewHandle:read("*a")
brewHandle:close()

-- throw error when brewPath nil
if not brewPath then
  error("Brew Path cannot be found")
end

return {
  "mfussenegger/nvim-jdtls",
  opts = {
    -- this is merged with full_cmd
    cmd = brewPath .. "/bin/jdtls",
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
        maven = {
          downloadSources = true,
        },
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
}
