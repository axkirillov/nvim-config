-- Thunk buffers: start the built-in Tree-sitter highlighter and set
-- comment/indent conventions. The parser lives at parser/thunk.so and the
-- queries at queries/thunk/ in this config; folding uses the global
-- vim.treesitter.foldexpr() set in settings.lua.

-- pcall so a missing/old parser degrades gracefully instead of erroring.
pcall(vim.treesitter.start)

vim.bo.commentstring = "// %s"
vim.bo.comments = "s1:/*,mb:*,ex:*/,://"

-- Examples are indented with 4 spaces.
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.tabstop = 4
