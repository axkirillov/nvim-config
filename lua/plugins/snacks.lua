local function get_relative_path()
	local relative_path = vim.fn.expand('%:.')
	vim.fn.setreg('*', relative_path)
	return relative_path
end

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
		local aider_opts = {
			interactive = true,
			win = {
				relative = "editor",
				position = "bottom",
				height = 100,
			},
		}
		local toggle_aider = function()
			snacks.terminal.toggle("aider", aider_opts)
		end
		vim.api.nvim_create_autocmd(
			{ "VimEnter" },
			{
				callback = function()
					toggle_aider()
					toggle_aider()
				end,
			}
		)
		vim.keymap.set(
			{ "n", "t" },
			"<M-a>",
			function()
				toggle_aider()
				-- reload current buffer if it was changed
				vim.cmd("checktime")
			end,
			{ noremap = true, silent = true }
		)
		vim.api.nvim_create_user_command(
			"AddFileToAider",
			function()
				local relative_path = get_relative_path()
				toggle_aider()
				vim.api.nvim_feedkeys("/add " .. relative_path, "n", false)
			end,
			{}
		)
		vim.api.nvim_create_user_command(
			"RunTestInAider",
			function()
				-- get the only the file name (without extention and path)
				local relative_path = vim.fn.expand('%:t:r')
				toggle_aider()
				--paste file path
				vim.api.nvim_feedkeys("/test ./test.sh " .. relative_path, "n", false)
			end,
			{}
		)
	end
}
