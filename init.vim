if &shell =~# 'fish$'
set shell=sh
endif

set tabstop=2
set shiftwidth=2

set sc
set number
set shiftwidth=0
set splitright
set wildmenu
set tabpagemax=50
set incsearch
set scrolloff=10
set backspace=start
set awa
set background=dark
set clipboard=unnamedplus

syntax on
filetype plugin indent on

"mappings
runtime mappings.vim
"autocommands
runtime autocommands.vim
"commands
runtime commands.vim

lua require("lazy_bootstrap")
lua require("lazy").setup("plugins", {change_detection = { enabled = true, notify = false} })
lua require("mappings")
lua require("settings")

colorscheme catppuccin-macchiato " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
