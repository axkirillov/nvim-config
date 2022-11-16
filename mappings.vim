map <space> <leader>

" disable arrow navigation
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" remap paragraph  navigation
noremap <C-b> {
noremap <C-d> }

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
nmap <F2> "=localtime()<C-M>p

"open diagnostic in a float window
nmap <leader>dof :lua vim.diagnostic.open_float()<CR>

"find the last link in terminal buffer
tnoremap <c-o> <c-\><c-n>?http<cr>
