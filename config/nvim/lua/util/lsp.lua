local M = {}

local function on_attach(bufnum, client_id)
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnum, desc = desc })
  end

  -- code mapings
  nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  nmap("<leader>ck", vim.lsp.buf.signature_help, "Code Signature")
  nmap("<leader>cs", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
  nmap("<leader>ci", require("telescope.builtin").lsp_implementations, "Find Implementation")
  nmap("<leader>cr", require("telescope.builtin").lsp_references, "Find References")
  nmap("<leader>cd", require("telescope.builtin").lsp_definitions, "Goto Definition")

  -- goto mappings
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
      ensure_installed = ft,
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

function M.ensure_dap(pkg)
  return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        dap = {
          pkg,
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

function M.ensure_lang(opts)
  opts = opts or {}
  local plugins = opts.other or {}

  table.insert(plugins, M.ensure_treesitter(opts.parsers or opts.ft))

  if opts.lsp then
    table.insert(plugins, M.ensure_lsp(opts.lsp))
  end

  if opts.formatters then
    for _, ft in ipairs(opts.ft) do
      for _, pl in ipairs(M.ensure_formatters(ft, opts.formatters)) do
        table.insert(plugins, pl)
      end
    end
  end

  if opts.dap then
    table.insert(plugins, M.ensure_dap(opts.dap))
  end

  if opts.test_adapter then
    table.insert(plugins, {
      "nvim-neotest/neotest",
      opts = {
        adapters = {
          opts.test_adapter,
        },
      },
    })
  end

  return plugins
end

return M
