return {
	"hedyhli/outline.nvim",
	config = function()
		-- Example mapping to toggle outline
		vim.keymap.set(
			"n",
			"<leader>o",
			"<cmd>Outline<CR>",
			{ desc = "Toggle Outline" }
		)

		require("outline").setup {
			outline_window = {
				auto_jump = true,
				auto_close = true,
				focus_on_open = true,
			},
			outline_items = {
				show_symbol_details = false,
			},
			keymaps = {
				goto_location = '<C-j>',
			},
		}
	end,
}
