local setup_files = function()
	require('mini.files').setup(
		{
			mappings = {
				close       = 'q',
				go_in       = '',
				go_in_plus  = '<C-f>',
				go_out      = '<C-b>',
				go_out_plus = '<H>',
				mark_goto   = "'",
				mark_set    = 'm',
				reset       = '<BS>',
				reveal_cwd  = '@',
				show_help   = 'g?',
				synchronize = '<c-y>',
				trim_left   = '<',
				trim_right  = '>',
			}
		}
	)
	vim.keymap.set(
		'n',
		'<c-m>',
		function()
			if not MiniFiles.close() then
				MiniFiles.open(vim.api.nvim_buf_get_name(0))
				MiniFiles.reveal_cwd()
			end
		end
	)
	vim.api.nvim_create_autocmd('User', {
		pattern = 'MiniFilesBufferCreate',
		callback = function(args)
			local buf_id = args.data.buf_id
			vim.keymap.set('n', '<c-n>', 'j', { buffer = buf_id })
			vim.keymap.set('n', '<c-p>', 'k', { buffer = buf_id })
			-- <CR> (your C-j sends Enter) as "enter/open" -- mirrors go_in_plus
			vim.keymap.set('n', '<cr>', function()
				MiniFiles.go_in({ close_on_file = true })
			end, { buffer = buf_id })
		end,
	})
end

local setup_bracketed = function()
	require('mini.bracketed').setup()
	-- needs to be remapped because otherwise the default diagnostic is going to be showed
	-- and we are using tiny-inline-diagnostic
	local opts = { noremap = true, silent = true }

	vim.keymap.set(
		'n',
		'[d',
		function()
			vim.diagnostic.jump({ count = -1, float = false })
		end,
		opts
	)

	vim.keymap.set(
		'n',
		']d',
		function()
			vim.diagnostic.jump({ count = 1, float = false })
		end,
		opts
	)
end


return {
	'echasnovski/mini.nvim',
	version = '*',
	config = function()
		setup_files()
		setup_bracketed()
		require('mini.splitjoin').setup({
			mappings = { toggle = 'gj' },
		})
	end
}
