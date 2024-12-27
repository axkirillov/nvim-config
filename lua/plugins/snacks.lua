return
{
	"folke/snacks.nvim",
	opts = {
		lazygit = {
			config = {
				os = { editPreset = "nvr" }
			}
		}
	},
	config = function()
		local snacks = require("snacks")
		vim.keymap.set("n", "<C-g>", function() snacks.lazygit() end, { noremap = true, silent = true })
	end
}
