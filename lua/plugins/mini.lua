return {
	'echasnovski/mini.nvim',
	version = '*',
	config = function()
		require('mini.files').setup()
		-- configure a keymap
		-- MiniFiles.open(vim.api.nvim_buf_get_name(0))
		vim.keymap.set('n', '<c-n>', function()
			MiniFiles.open(vim.api.nvim_buf_get_name(0))
      MiniFiles.reveal_cwd()
		end)
	end
}
