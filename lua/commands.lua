-- Turn syntax folding on (closes all folds automatically)
vim.api.nvim_create_user_command('Foldall', 'set fdm=syntax', {})

-- Format JSON using jq
vim.api.nvim_create_user_command('Jq', function()
	vim.cmd('%!jq')
	vim.o.syntax = 'json'
end, {})

-- Frequent typos
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('Qa', 'qa', {})

-- Open line in GitHub
vim.api.nvim_create_user_command('OpenLineInGithub', '.GBrowse', {})

-- Replace tabs with spaces
vim.api.nvim_create_user_command('ReTab', '%s/\\t/  /g', {})

-- Copy file path
vim.api.nvim_create_user_command('CopyFilePath', function()
	local relative_path = vim.fn.expand('%:.')
	vim.fn.setreg('*', relative_path)
end, {})

-- Paste unix timestamp
vim.api.nvim_create_user_command(
	'PasteTimestamp',
	function()
		local timestamp = vim.fn.substitute(vim.fn.system('gdate +%s%3N'), '\\n\\+$', '', '')
		vim.api.nvim_put({ timestamp }, 'c', true, true)
	end,
	{}
)
