"turn syntax folding on (closes all folds automatically)
command Foldall set fdm=syntax

"format json using jq
command Jq :execute '%!jq' | :set syntax=json
