" Vimspector
" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

"activate human mappings
let g:vimspector_enable_mappings = 'HUMAN'
