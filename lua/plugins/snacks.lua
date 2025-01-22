return
{
	"folke/snacks.nvim",
	opts = {
		lazygit = {
			config = {
				os = {
					editPreset = "nvim-remote",
					--    this does not work, i dunno why
					edit =
					'[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})'
				}
			}
		},
		terminal = {

		},
	},
	config = function()
		local snacks = require("snacks")
		vim.keymap.set("n", "<C-g>", function() snacks.lazygit() end, { noremap = true, silent = true })
		vim.keymap.set(
			{ "n", "t" },
			"<C-t>",
			function()
				snacks.terminal.toggle()
				-- reload current buffer if it was changed
				vim.cmd("checktime")
			end,
			{ noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n", },
			"<leader>a",
			function()
				-- get current file path
				local filepath = vim.api.nvim_buf_get_name(0)
				snacks.terminal.toggle()
				--paste file path
				vim.api.nvim_feedkeys("/add " .. filepath, "n", false)
			end,
			{ noremap = true, silent = true }
		)
	end
}
