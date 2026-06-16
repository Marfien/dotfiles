return {
  cmd = { "lemminx" },
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
  root_markers = { ".git" },
  init_options = {
    settings = {
      xml = {
        format = {
          enabled = true,
          splitAttributes = "preserve",
          maxLineWidth = 280,
        },
      },
      xslt = {
        format = {
          enabled = true,
          splitAttributes = "preserve",
          maxLineWidth = 280,
        },
      },
    },
  },
}
