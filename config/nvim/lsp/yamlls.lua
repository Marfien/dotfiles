return {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or client.name ~= "yamlls" then
      return
    end

    vim.lsp.config("yamlls", {
      on_new_config = function(new_config)
        new_config.settings.yaml.schemas =
          vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
      end,
      settings = {
        yaml = {
          keyOrdering = false,
          format = {
            enable = true,
          },
          validate = true,
          schemaStore = {
            -- Must disable built-in schemaStore support to use
            -- schemas from SchemaStore.nvim plugin
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = "",
          },
          customTags = {
            "!reference sequence",
          },
        },
      },
    })
  end,
}
