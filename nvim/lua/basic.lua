local opt = vim.opt
local g = vim.g

----------- globals --------------
g.transparency = 0.90
g.foldenable = false

-- leader and localleader
g.mapleader = " "
g.maplocalleader = " "

----------- options --------------
opt.autowrite = true
opt.laststatus = 0
opt.showmode = false
opt.signcolumn = "yes:1"

opt.clipboard = "unnamedplus"
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.smarttab = true
opt.shiftround = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

opt.number = true
opt.numberwidth = 2
opt.ruler = false

opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true

opt.splitkeep = "screen"
opt.shortmess:append({ C = true })
