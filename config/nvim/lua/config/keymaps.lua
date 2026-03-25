vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap
local map = keymap.set

-- disable arrow keys
for _, mapping in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
  pcall(keymap.del, { "n", "v" }, mapping)
end

-- Movement
-- better up/down movement for wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map("n", "<C-a>", "GA", { remap = true })
map({ "n", "v" }, "0", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.cmd.normal("^")
  if col == vim.api.nvim_win_get_cursor(0)[2] then
    vim.api.nvim_win_set_cursor(0, { row, 0 })
  end
end)

-- move between windows/panes
local function map_windowmove(key, direction)
  local cmd = "<cmd>wincmd " .. key .. "<cr>"
  local lhs = "<C-" .. key .. ">"
  local opts = { desc = "Go to " .. direction .. " Window", remap = true }
  map("n", lhs, cmd, opts)
  map("i", lhs, "<esc>" .. cmd, opts)
end

map_windowmove("h", "Left")
map_windowmove("j", "Lower")
map_windowmove("k", "Upper")
map_windowmove("l", "Right")

-- buffers
map("n", "<S-h>", function()
  if vim.bo.buflisted then
    vim.cmd.bprevious()
  else
    vim.notify("Buf not listed.", vim.log.levels.WARN)
  end
end, { desc = "Prev Buffer" })

map("n", "<S-l>", function()
  if vim.bo.buflisted then
    vim.cmd.bnext()
  else
    vim.notify("Buf not listed.", vim.log.levels.WARN)
  end
end, { desc = "Next Buffer" })

-- Taps
map("n", "<tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<tab><tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<tab>\\", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<tab>x", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- unified search behavior
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("n", "<ESC>", "<cmd>noh<cr>", { desc = "End Highlighting" })

-- easier indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Lazy UI
map("n", "<leader>.l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Window management
map("n", "<leader>wh", "<C-W>s", { desc = "Split Below", remap = true })
map("n", "<leader>wv", "<C-W>v", { desc = "Split Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete", remap = true })

-- disable default lsp keymaps
for _, bind in ipairs({ "grt", "grn", "gra", "gri", "grr" }) do
  local ok, _ = pcall(keymap.del, "n", bind)
  if not ok then
    vim.notify("Could not remove mapping: " .. bind, vim.log.levels.ERROR)
  end
end

-- lsp
map({ "n", "x" }, "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map({ "n", "x" }, "<leader>ck", vim.lsp.buf.signature_help, { desc = "Code Signature" })
map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Code Signature" })
map({ "n", "x" }, "K", vim.lsp.buf.hover, { desc = "Hover Documentation" }) -- See `:help K` for why this keymap

-- sessions
map("n", "<leader>ss", require("util.session").store, { desc = "Store" })
map("n", "<leader>sl", require("util.session").load, { desc = "Load" })
