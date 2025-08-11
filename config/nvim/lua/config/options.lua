-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g

--
-- Clipboard
--
if os.getenv("WSL_INTEROP") ~= nil or os.getenv("WSL_DISTRO_NAME") ~= nil then
  -- Windows clipboard
  g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -noprofile -command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -noprofile -command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
else
  opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
end

-- Keep cursor in vertical center
opt.scrolloff = 999

-- Spell Checking
opt.spell = true
opt.spelllang = { "en", "de" }
opt.spellsuggest = { "best", 5 }
opt.spelloptions = { "camel" }
