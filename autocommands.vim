"turn search highlight off on command mode leave
augroup ToggleSearchHighlighting
au!
autocmd CmdlineEnter \?,/ set hlsearch
autocmd CmdlineLeave \?,/ set nohlsearch
augroup END
