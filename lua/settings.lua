vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.showcmd = true
vim.opt.number = true
vim.opt.splitright = true
vim.opt.wildmenu = true
vim.opt.tabpagemax = 50
vim.opt.incsearch = true
vim.opt.scrolloff = 10
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.autowrite = true
vim.opt.background = 'dark'
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'

-- fold options
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
vim.opt.foldlevel = 99

vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

vim.g.mapleader = ' '
