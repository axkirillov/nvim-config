map <space> <leader>

"disable arrow navigation
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

"to exit terminal mode
tnoremap <C-e> <C-\><C-n>

"copy file path to clipboard
nmap cp :let @* = expand("%")<cr>

"yank to clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y

"create file and path under cursor and open it in a buffer
map <leader>cf :!mkdir -p "$(dirname <cfile>)"<CR> :e <cfile><CR>

"paste unix timestamp
nmap <silent> <F2> "= substitute(system('gdate +%s%3N'), '\n\+$', '', '')<cr>p

"open diagnostic in a float window
nmap <leader>df :lua vim.diagnostic.open_float()<CR>

"close quickfix
map <silent> <C-c> :ccl<cr>

"more comfortable movement
map H ^
map L $
map J }
map K {

"give a new home to J
noremap M J

"lazygit
map <silent> <C-g> :!tmux split-window -Z -c "\#{pane_current_path}" "lazygit"<cr>

"popup terminal
map <silent> <F1> :!tmux popup -E -w 160 -h 40 -d $(pwd)<cr>

"gb to open git blame (requires fugitive)
nnoremap <silent> gb :Gblame<CR>
