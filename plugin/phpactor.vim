"augroup PhpactorMappings
"	au!
"	au FileType php nmap <buffer> <Leader>u :PhpactorImportClass<CR>
"	au FileType php nmap <buffer> <Leader>e :PhpactorClassExpand<CR>
"	au FileType php nmap <buffer> <Leader>ua :PhpactorImportMissingClasses<CR>
"	au FileType php nmap <buffer> <Leader>mm :PhpactorContextMenu<CR>
"	au FileType php nmap <buffer> <Leader>nn :PhpactorNavigate<CR>
"	au FileType php,cucumber nmap <buffer> <Leader>o :PhpactorGotoDefinition edit<CR>
"	au FileType php nmap <buffer> <Leader>ppt :PhpactorTransform<CR>
"	au FileType php nmap <buffer> <Leader>cc :PhpactorClassNew<CR>
"	au FileType php nmap <buffer> <Leader>mf :PhpactorMoveFile<CR>
"	au FileType php nmap <buffer> <silent> <Leader>ee :PhpactorExtractExpression<CR>
"	au FileType php vmap <buffer> <silent> <Leader>ee :<C-u>PhpactorExtractExpression<CR>
"	au FileType php vmap <buffer> <silent> <Leader>em :<C-u>PhpactorExtractMethod<CR>
"augroup END
