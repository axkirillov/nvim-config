-- Turn syntax folding on (closes all folds automatically)
vim.api.nvim_create_user_command('Foldall', 'set fdm=syntax', {})

-- Format JSON using jq
vim.api.nvim_create_user_command('Jq', function()
	vim.cmd('%!jq')
	vim.o.syntax = 'json'
end, {})

-- Set syntax to gotmpl
vim.api.nvim_create_user_command('GoTmpl', 'set filetype=gotmpl', {})

-- Add strict_types to PHP files
vim.api.nvim_create_user_command('AddPHPStrictTypes', function()
	local cursor_save = vim.fn.getpos('.')

	-- Go to the beginning of the file
	vim.fn.cursor(1, 1)

	-- Find the line containing "<?php"
	local phpLine = vim.fn.search('<?php')

	-- Check if declaration isn't already present
	if vim.fn.search('<?php\n\ndeclare(strict_types=1);') == 0 and phpLine ~= 0 then
		-- Add the declaration after the line
		vim.fn.append(phpLine, { "", "declare(strict_types=1);" })
	end

	-- Restore cursor position
	vim.fn.setpos('.', cursor_save)
end, {})

-- Frequent typos
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('Qa', 'qa', {})

-- Close all buffers but the current one
vim.api.nvim_create_user_command('CloseAllButThisOne', function()
	vim.cmd('%bd')
	vim.cmd('e#')
end, {})

-- Toggle LSP lines
vim.api.nvim_create_user_command('LspLines', function()
	require("lsp_lines").toggle()
end, {})

-- Open line in GitHub
vim.api.nvim_create_user_command('OpenLineInGithub', '.GBrowse', {})

-- Replace tabs with spaces
vim.api.nvim_create_user_command('ReTab', '%s/\\t/  /g', {})
