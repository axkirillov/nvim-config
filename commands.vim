"turn syntax folding on (closes all folds automatically)
command Foldall set fdm=syntax

"format json using jq
command Jq :execute '%!jq' | :set syntax=json

"set syntax to gotmpl
command GoTmpl set filetype=gotmpl 
