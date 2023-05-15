let g:floaterm_shell="fish"
let g:floaterm_width=0.95
let g:floaterm_height=0.9
let g:floaterm_opener="edit"

nnoremap <silent> <F1> :FloatermToggle<CR>
tnoremap <silent> <F1> <C-\><C-n>:FloatermToggle<CR>

"lazygit
map <silent> <C-g> :!tmux split-window -Z "lazygit"<cr>
