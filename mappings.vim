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
nmap <F2> "=localtime()<C-M>p

"open diagnostic in a float window
nmap <leader>df :lua vim.diagnostic.open_float()<CR>

"close quickfix
map <C-c> :ccl<cr>

"copilot accept suggestion
imap <silent><script><expr> <C-F> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

"more comfortable movement
map H ^
map L $
map J }
map K {

"give a new home to J
noremap M J
