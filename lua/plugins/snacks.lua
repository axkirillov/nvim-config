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
				local relative_path = vim.fn.expand('%:.')
				vim.fn.setreg('*', relative_path)
				snacks.terminal.toggle()
				--paste file path
				vim.api.nvim_feedkeys("/add " .. relative_path, "n", false)
			end,
			{ noremap = true, silent = true }
		)
		vim.api.nvim_create_user_command(
			"RunTest",
			function()
				-- get the only the file name (without extention and path)
				local relative_path = vim.fn.expand('%:t:r')
				snacks.terminal.open("./test.sh " .. relative_path, { interactive = false })
			end,
			{}
		)
	end
}
