vim.keymap.set('n', ']h', function() require('unified.navigation').next_hunk() end)
vim.keymap.set('n', '[h', function() require('unified.navigation').previous_hunk() end)

-- Add custom command to show diff between merge-base and HEAD
vim.api.nvim_create_user_command(
	'DiffMergeBase',
	function()
		-- Get the default branch name
		local default_branch = vim.fn.trim(vim.fn.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5"))
		-- Get the merge-base commit
		local merge_base = vim.fn.trim(vim.fn.system('git merge-base HEAD ' .. default_branch))
		-- Open diffview between merge-base and HEAD
		vim.cmd('Unified ' .. merge_base)
	end,
	{ desc = 'Open diff between merge-base and HEAD' }
)

return {
	dir = '~/repo/unified.nvim',
	opts = {},
}
