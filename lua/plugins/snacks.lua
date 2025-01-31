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
		input = {
		},
		picker = {
		},
	},
	config = function()
		local snacks = require("snacks")
		vim.keymap.set("n", "<C-g>", function() snacks.lazygit() end, { noremap = true, silent = true })
	end
}
