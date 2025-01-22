if vim.o.shell:match('fish$') then
	--vim.o.shell = 'sh'
end

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.showcmd = true
vim.opt.number = true
vim.opt.splitright = true
vim.opt.wildmenu = true
vim.opt.tabpagemax = 50
vim.opt.incsearch = true
vim.opt.scrolloff = 10
vim.opt.backspace = 'start'
vim.opt.autowrite = true
vim.opt.background = 'dark'
vim.opt.clipboard = 'unnamedplus'

-- fold opitions
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
vim.opt.foldlevel = 99

vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

vim.g.mapleader = ' '

