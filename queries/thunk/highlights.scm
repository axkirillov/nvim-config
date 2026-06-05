; Thunk syntax highlighting.
; Generic captures come first; more specific captures below override them
; (Neovim applies the later-defined capture at equal priority).

; --- references (generic; overridden below where more is known) ---
(identifier) @variable

; --- identifier roles ---
(parameter
  name: (identifier) @variable.parameter)

(call_expression
  function: (identifier) @function.call)

; a `let` bound directly to a function literal names a function
(let_declaration
  name: (identifier) @function
  value: (function))

; --- types ---
(type_identifier) @type

((type_identifier) @type.builtin
  (#any-of? @type.builtin "Int" "Bool"))

; --- literals ---
(integer_literal) @number
(boolean_literal) @boolean

; --- comments ---
[
  (line_comment)
  (block_comment)
] @comment @spell

; --- keywords ---
"let" @keyword
"fn" @keyword.function

[
  "if"
  "else"
] @keyword.conditional

; --- operators ---
[
  "+"
  "-"
  "*"
  "/"
  "=="
  "!="
  "<"
  ">"
  "<="
  ">="
  "="
] @operator

; --- punctuation ---
[
  "("
  ")"
  "{"
  "}"
] @punctuation.bracket

[
  ","
  ";"
  ":"
] @punctuation.delimiter
