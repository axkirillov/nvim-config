return {
	'nvim-telescope/telescope.nvim', tag = '0.1.0',
	dependencies = {
		{ 'nvim-lua/plenary.nvim' },
	},
	config = function()
		require("plugins.telescope")
	end,
}

