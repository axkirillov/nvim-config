if &shell =~# 'fish$'
set shell=sh
endif

" this fixes the vim bug that lead to incorrect background color in kitty
let &t_ut=''

set tabstop=4
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

"competion menu options to work nicely with autocomplete
set completeopt=menu,menuone,noselect


syntax on
filetype plugin indent on

"mappings
runtime mappings.vim
"autocommands
runtime autocommands.vim
"commands
runtime commands.vim

lua require("lazy_bootstrap")
lua require("lazy").setup("plugins_lazy", {change_detection = { enabled = true, notify = false} })
lua require("plugins")
lua require("mappings")

colorscheme catppuccin-macchiato " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
