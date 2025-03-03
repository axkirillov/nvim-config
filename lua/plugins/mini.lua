local setup_files = function()
	require('mini.files').setup(
		{
			mappings = {
				close       = 'q',
				go_in       = 'l',
				go_in_plus  = '<c-j>',
				go_out      = 'h',
				go_out_plus = 'H',
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
end

return {
	'echasnovski/mini.nvim',
	version = '*',
	config = function()
		setup_files()
		require('mini.bracketed').setup()
	end
}
