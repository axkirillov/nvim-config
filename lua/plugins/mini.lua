return {
	'echasnovski/mini.nvim',
	version = '*',
	config = function()
		local config = {
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

		require('mini.files').setup(config)

		vim.keymap.set('n', '<c-n>', function()
			MiniFiles.open(vim.api.nvim_buf_get_name(0))
			MiniFiles.reveal_cwd()
		end)
	end
}
