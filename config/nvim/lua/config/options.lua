local opt = vim.opt

opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard

-- fully disable mouse
opt.mouse = ""

-- Spell Checking
opt.spell = true
-- opt.spelllang = { "en", "de" }
opt.spellsuggest = { "best", 5 }
opt.spelloptions = { "camel" }
opt.smartcase = true

-- ui stuff
opt.termguicolors = true
opt.pumblend = 10
opt.pumheight = 10
opt.ruler = false

-- editor
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.scrolloff = 20
opt.sidescrolloff = 10
opt.list = true
opt.number = true -- show line number
opt.relativenumber = true
opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- reduce status messages
opt.showmode = false -- > lualine
opt.signcolumn = "yes"
opt.timeoutlen = 300
opt.updatetime = 200 -- write swap after this many ms
opt.wildmode = "longest:full,full"
opt.wrap = false

-- folding
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.foldtext = ""
opt.foldmethod = "expr"
opt.foldtext = "v:lua.require'util.ui'.foldexpr()"

-- formatting
opt.formatexpr = "v:lua.require'conform'.formatexpr()" -- use conform as formatter
opt.formatoptions = "jcroqlnt" -- how to format text -> :h fo-table
opt.linebreak = true

-- grep config
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true

opt.inccommand = "nosplit" -- preview incremental substitution
opt.jumpoptions = "view"

opt.splitbelow = true
opt.splitright = true

-- indenting
opt.shiftround = true
opt.shiftwidth = 2
opt.tabstop = 2

-- undo history
opt.undofile = true
opt.undolevels = 10000
