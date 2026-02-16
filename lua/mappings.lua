local opts = { expr = true }

-- delete to black hole register if line is empty
vim.keymap.set("n", "dd", function ()
	if vim.fn.getline(".") == "" then return '"_dd' end
	return "dd"
end, opts)

-- Exit terminal mode
vim.keymap.set('t', '<M-e>', '<C-\\><C-n>')

-- Make <C-l> behave like normal mode (redraw) in terminal mode
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-l>i', { silent = true, desc = 'Redraw (terminal)' })

vim.keymap.set('t', '<M-h>', '<C-\\><C-n><C-w>h', { silent = true, desc = 'Window left' })
vim.keymap.set('t', '<M-j>', '<C-\\><C-n><C-w>j', { silent = true, desc = 'Window down' })
vim.keymap.set('t', '<M-k>', '<C-\\><C-n><C-w>k', { silent = true, desc = 'Window up' })
vim.keymap.set('t', '<M-l>', '<C-\\><C-n><C-w>l', { silent = true, desc = 'Window right' })
vim.keymap.set('t', '<M-p>', '<C-\\><C-n><C-w>p', { silent = true, desc = 'Window previous' })

-- Open diagnostic in a float window
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float)

-- Close quickfix
vim.keymap.set('n', '<C-c>', ':ccl<cr>')

-- Give a new home to J
vim.keymap.set('n', 'M', 'J')

-- set HJKL to noop
vim.keymap.set('n', 'H', '<nop>')
vim.keymap.set('n', 'J', '<nop>')
vim.keymap.set('n', 'K', '<nop>')
vim.keymap.set('n', 'L', '<nop>')

-- open vscode in current directory
vim.keymap.set('n', '<F8>', function()
	local cwd = vim.fn.getcwd()
	-- Spawn VS Code without blocking Neovim.
	vim.system({ "code", "--goto", cwd }, { detach = true })
end)
