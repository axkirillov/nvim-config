return {
	"hedyhli/outline.nvim",
	config = function()
		-- Example mapping to toggle outline
		vim.keymap.set(
			"n",
			"<leader>o",
			"<cmd>OutlineFocus<CR>",
			{ desc = "Toggle Outline" }
		)

		require("outline").setup {
			outline_window = {
				auto_jump = true,
				width = 15,
				focus_on_open = false,
			},
			outline_items = {
				show_symbol_details = false,
			},
			keymaps = {
				goto_location = '<C-j>',
			},
		}
		require("outline").open()
	end,
}
