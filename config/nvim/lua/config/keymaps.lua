vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap
local map = keymap.set

-- disable arrow keys
pcall(keymap.del, { "n", "v" }, "<Up>")
pcall(keymap.del, { "n", "v" }, "<Down>")
pcall(keymap.del, { "n", "v" }, "<Left>")
pcall(keymap.del, { "n", "v" }, "<Right>")

-- better up/down movement for wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- move between windows/panes
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

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
map("i", "C-K", vim.lsp.buf.signature_help, { desc = "Code Signature" })
map({ "n", "x" }, "<leader>cD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map({ "n", "x" }, "K", vim.lsp.buf.hover, { desc = "Hover Documentation" }) -- See `:help K` for why this keymap

-- sessions
map("n", "<leader>ss", require("util.session").store, { desc = "Store" })
map("n", "<leader>sl", require("util.session").load, { desc = "Load" })
