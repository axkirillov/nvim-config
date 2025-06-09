vim.keymap.set('n', ']h', function() require('unified.navigation').next_hunk() end)
vim.keymap.set('n', '[h', function() require('unified.navigation').previous_hunk() end)

return {
	dir = '~/repo/unified.nvim',
	opts = {},
}
