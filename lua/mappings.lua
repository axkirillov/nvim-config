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

-- Give a new home to J
vim.keymap.set('', 'M', 'J')

-- set HJKL to noop
vim.keymap.set('', 'H', '<nop>')
vim.keymap.set('', 'J', '<nop>')
vim.keymap.set('', 'K', '<nop>')
vim.keymap.set('', 'L', '<nop>')

-- open vscode in current directory
vim.keymap.set('n', '<F8>', function()
	local cwd = vim.fn.getcwd()
	local cmd = string.format("code --goto %s", cwd)
	vim.fn.system(cmd)
end)
