local keymap_opts = {
	noremap = true,
	silent = true,
}

return
{
	"folke/snacks.nvim",
	opts = {
		lazygit = {
			config = {
				os = {
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
		vim.keymap.set("n", "<C-g>", function() snacks.lazygit() end, keymap_opts)

		vim.keymap.set(
			{ "n", "t" },
			"<F1>",
			function()
				snacks.terminal.toggle(
					"claude",
					{
						auto_close = false,
						win = { position = "float" },
					}
				)
				vim.cmd("checktime")
			end,
			keymap_opts
		)

		vim.keymap.set(
			{ "n", "t" },
			"<F2>",
			function()
				snacks.terminal.toggle(
					nil,
					{
						auto_close = false,
						win = { position = "float" },
					}
				)
				vim.cmd("checktime")
			end,
			keymap_opts
		)
	end
}
