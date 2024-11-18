"turn syntax folding on (closes all folds automatically)
command Foldall set fdm=syntax

"format json using jq
command Jq :execute '%!jq' | :set syntax=json

"set syntax to gotmpl
command GoTmpl set filetype=gotmpl 

" adds strict_types to the file
function! AddPHPStrictTypesFunc()
    " Save the cursor position
    let cursor_save = getpos('.')

    " Go to the begining of the file
    call cursor(1, 1)

    " Get the line containing "<?php"
    let phpLine = search('<?php')

    " If the declaration isn't in the buffer and there is one line containing "<?php"
    if search('<?php\n\ndeclare(strict_types=1);') == 0 && phpLine != 0
        " Add the declaration after the line
        call append(phpLine, "declare(strict_types=1);")
		call append(phpLine, "")
    endif

    " Restore cursor position
    call setpos('.', cursor_save)
endfunction

command AddPHPStrictTypes :call AddPHPStrictTypesFunc()

" frequent typos
command W :w
command Wq :wq
command Q :q
command Qa :qa

" close all buffers but this one
command CloseAllButThisOne :%bd|e#

command LspLines :lua require("lsp_lines").toggle()

command OpenLineInGithub .GBrowse

" replace tabs with spaces
command ReTab :%s/\t/  /g
