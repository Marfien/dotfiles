local ignored_filetypes = {
  "starer",
  "help",
  "term",
  "neotest-output-panel",
  "vim",
  "touble",
  "qf",
}

return {
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
        predicate = function(scope)
          return not scope.body.is_incomplete and not vim.tbl_contains(ignored_filetypes, vim.bo[scope.buf_id].filetype)
        end,
      },
      symbol = "▏",
    },
  },
}
