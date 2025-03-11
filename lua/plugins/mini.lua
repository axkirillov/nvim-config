local setup_files = function()
	require('mini.files').setup(
		{
			mappings = {
				close       = 'q',
				go_in       = '',
				go_in_plus  = '<c-l>',
				go_out      = '<c-h>',
				go_out_plus = '<H>',
				mark_goto   = "'",
				mark_set    = 'm',
				reset       = '<BS>',
				reveal_cwd  = '@',
				show_help   = 'g?',
				synchronize = '=',
				trim_left   = '<',
				trim_right  = '>',
			}
		}
	)
	vim.keymap.set(
		'n',
		'<c-n>',
		function()
			MiniFiles.open(vim.api.nvim_buf_get_name(0))
			MiniFiles.reveal_cwd()
		end
	)
	vim.api.nvim_create_autocmd('User', {
		pattern = 'MiniFilesBufferCreate',
		callback = function(args)
			local buf_id = args.data.buf_id
			vim.keymap.set('n', '<c-j>', 'j', { buffer = buf_id })
			vim.keymap.set('n', '<c-k>', 'k', { buffer = buf_id })
		end,
	})
end

local setup_bracketed = function()
	require('mini.bracketed').setup()
	-- needs to be remapped bacause otherwise the default diagnostic is going to be showed
	-- and we are using tiny-inline-diagnostic
	local opts = { noremap = true, silent = true }

	vim.keymap.set(
		'n',
		'[d',
		function()
			vim.diagnostic.goto_prev({ float = false })
		end,
		opts
	)

	vim.keymap.set(
		'n',
		']d',
		function()
			vim.diagnostic.goto_next({ float = false })
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
	end
}
