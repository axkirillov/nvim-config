return {
	'puremourning/vimspector',
	config = function()
		vim.api.nvim_set_keymap("n", "<leader>vi", "<Plug>VimspectorBalloonEval", { noremap = true })
		vim.api.nvim_set_keymap("x", "<leader>vi", "<Plug>VimspectorBalloonEval", { noremap = true })
		vim.g.vimspector_enable_mappings = 'HUMAN'
	end,
}
