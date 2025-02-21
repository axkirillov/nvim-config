local opts = { expr = true }

-- delete to black hole register if line is empty
vim.keymap.set("n", "dd", function ()
	if vim.fn.getline(".") == "" then return '"_dd' end
	return "dd"
end, opts)

-- Exit terminal mode
vim.keymap.set('t', '<M-e>', '<C-\\><C-n>')

-- Open diagnostic in a float window
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float)

-- Close quickfix
vim.keymap.set('', '<C-c>', ':ccl<cr>')

-- More comfortable movement
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')
vim.keymap.set('', 'J', '}')
vim.keymap.set('', 'K', '{')

-- Give a new home to J
vim.keymap.set('', 'M', 'J')
