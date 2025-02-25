return {
	"hedyhli/outline.nvim",
	config = function()
		-- Example mapping to toggle outline
		local keymap_opts = { desc = "Toggle Outline" }
		vim.keymap.set(
			"n",
			"<C-h>",
			"<cmd>Outline<CR>",
			keymap_opts
		)

		require("outline").setup {
			outline_window = {
				auto_jump = true,
				auto_close = true,
				focus_on_open = true,
				width = 15,
				position = 'left',
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
