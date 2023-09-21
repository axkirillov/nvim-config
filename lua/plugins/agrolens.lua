return {
	"desdic/agrolens.nvim",
	dependencies = 'nvim-telescope/telescope.nvim',
	config = function()
		-- create a command to call Telescope agrolens query=functions
		vim.cmd [[
			command! -nargs=0 Functions Telescope agrolens query=functions
		]]
		vim.cmd [[
			nnoremap <silent> <leader>m <cmd>Functions<cr>
		]]
	end
}
