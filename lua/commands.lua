-- Turn syntax folding on (closes all folds automatically)
vim.api.nvim_create_user_command('Foldall', 'set fdm=syntax', {})

-- Format JSON using jq
vim.api.nvim_create_user_command('Jq', function()
	vim.cmd('%!jq')
	vim.o.syntax = 'json'
end, {})

-- Set syntax to gotmpl
vim.api.nvim_create_user_command('GoTmpl', 'set filetype=gotmpl', {})

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
