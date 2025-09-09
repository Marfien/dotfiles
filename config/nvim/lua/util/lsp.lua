local M = {}

local function on_attach(bufnum)
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnum, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  nmap("<leader>ck", vim.lsp.buf.signature_help, "Code Signature")
  nmap("<leader>cs", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols")
  nmap("<leader>ci", "<cmd>Telescope lsp_implementations<cr>", "Find Implementation")
  nmap("<leader>cr", "<cmd>Telescope lsp_references<cr>", "Find References")
  nmap("<leader>cd", "<cmd>Telescope lsp_definitions<cr>", "Goto Definition")
  nmap("<leader>cD", vim.lsp.buf.declaration, "Goto Declaration")

  pcall(vim.keymap.del, "n", "K", { buffer = bufnum })
  nmap("K", vim.lsp.buf.hover, "Hover Documentation") -- See `:help K` for why this keymap
end

local function setup_refactor(buf)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
  end

  map("x", "<leader>re", ":Refactor extract ")
  map("x", "<leader>rf", ":Refactor extract_to_file ")
  map("x", "<leader>rv", ":Refactor extract_var ")
  map({ "n", "x" }, "<leader>ri", "<cmd>Refactor inline_var<cr>")
  map("n", "<leader>rI", "<cmd>Refactor inline_func<cr>")
  map("n", "<leader>rb", "<cmd>Refactor extract_block<cr>")
  map("n", "<leader>rB", "<cmd>Refactor extract_block_to_file<cr>")
end

function M.autocmd()
  return {
    group = vim.api.nvim_create_augroup("lap_attach", {}),
    pattern = "*",
    callback = function(event)
      on_attach(event.buf)
    end,
  }
end

function M.ensure_linters(pkgs)
  return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        formatter = pkgs,
      },
    },
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

---@class util.lsp.LangSpec
---@field lsp string
---@field other? table<string>
---@field parsers? table<string>
---@field ft table
---@field formatters? table
---@field dap? string
---@field linters? table<string>
---@field test_adapter? function
---@field on_attach? function
---@field setup_refactor? boolean

---Definition
---@param opts util.lsp.LangSpec
---@return table
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

  if opts.linters then
    table.insert(plugins, M.ensure_linters(opts.linters))
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

  if opts.on_attach or opts.setup_refactor then
    vim.api.nvim_create_autocmd("LspAttach", {
      pattern = "*",
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client or client.name ~= "lua_ls" then
          return
        end

        if opts.on_attach then
          opts.on_attach(event.buf, client)
        end

        if opts.setup_refactor then
          setup_refactor(event.buf)
        end
      end,
    })
  end

  return plugins
end

return M
