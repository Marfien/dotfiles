local M = {}

function on_attach(bufnum, client_id)
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnum, desc = desc })
  end

  -- code mapings
  nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  nmap("<leader>ck", vim.lsp.buf.signature_help, "Code Signature")
  nmap("<leader>cs", require("telescope.builtin").lsp_document_symbols, "Code Symbols")
  nmap("<leader>cw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

  -- find mappings
  nmap("<leader>fi", require("telescope.builtin").lsp_implementations, "Find Implementation")
  nmap("<leader>fr", require("telescope.builtin").lsp_references, "Find References")

  -- goto mappings
  nmap("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")

  pcall(vim.keymap.del, "n", "K", { buffer = bufnum })
  nmap("K", vim.lsp.buf.hover, "Hover Documentation") -- See `:help K` for why this keymap
end

function M.autocmd()
  return {
    group = vim.api.nvim_create_augroup("lap_attach", {}),
    pattern = "*",
    callback = function(event)
      on_attach(event.buf, event.data.client_id)
    end,
  }
end

function M.ensure_treesitter(ft)
  return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        ft,
      },
    },
  }
end

function M.ensure_formatters(ft, pkgs)
  return {
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = {
        ensure_installed = {
          formatter = pkgs,
        },
      },
    },
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          [ft] = pkgs,
        },
      },
    },
  }
end

function M.ensure_lsp(pkg)
  return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        lsp = {
          pkg,
        },
      },
    },
  }
end

function M.lang_support(filetype, lsp, formatters, other)
  local plugins = other or {}

  table.insert(plugins, M.ensure_treesitter(filetype))

  if lsp then
    table.insert(plugins, M.ensure_lsp(lsp))
  end

  if formatters then
    local formatter_configs = M.ensure_formatters(filetype, formatters)
    table.insert(plugins, formatter_configs[1])
    table.insert(plugins, formatter_configs[2])
  end

  return plugins
end

return M
