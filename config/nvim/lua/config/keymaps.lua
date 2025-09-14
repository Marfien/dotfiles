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

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- buffers
local buffers = require("util.buffers")
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bd", function()
  buffers.delete()
end, { desc = "Delete current buffer" })
map("n", "<leader>bo", function()
  buffers.delete({ filter = buffers.others })
end, { desc = "Delete other buffers" })
map("n", "<leader>bD", function()
  buffers.delete({ filter = buffers.all })
end, { desc = "Delete current buffer and window" })

-- unified search behavior
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("n", "<ESC>", "<cmd>noh<cr>", { desc = "End Highlighting" })

-- easier indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Lazy UI
map("n", "<leader>.l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Window management
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- TODO:
-- locations
-- quickfixes

-- disable default lsp keymaps
for _, bind in ipairs({ "grt", "grn", "gra", "gri", "grr" }) do
  local ok, _ = pcall(keymap.del, "n", bind)
  if not ok then
    vim.notify("Could not remove mapping: " .. bind, vim.log.levels.ERROR)
  end
end
