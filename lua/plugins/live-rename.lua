return {
	"saecki/live-rename.nvim",
	config = function()
		local live_rename = require("live-rename")
		live_rename.setup({
			keys = {
				submit = {
					{ "n", "<c-j>" },
					{ "v", "<c-j>" },
					{ "i", "<c-j>" },
				},
				cancel = {
					{ "n", "<esc>" },
					{ "n", "q" },
				},
			},
		})
		local bufopts = { noremap = true, silent = true }
		vim.keymap.set('n', '<leader>rn', live_rename.rename, bufopts)
	end
}
