local function get_relative_path()
	local relative_path = vim.fn.expand('%:.')
	vim.fn.setreg('*', relative_path)
	return relative_path
end

return {
	"GeorgesAlkhouri/nvim-aider",
	lazy = false,
	keys = {
		--{ "<leader>a/", "<cmd>AiderTerminalToggle<cr>", desc = "Open Aider" },
		--{ "<leader>as", "<cmd>AiderTerminalSend<cr>", desc = "Send to Aider", mode = { "n", "v" } },
		--{ "<leader>ac", "<cmd>AiderQuickSendCommand<cr>", desc = "Send Command To Aider" },
		--{ "<leader>ab", "<cmd>AiderQuickSendBuffer<cr>", desc = "Send Buffer To Aider" },
		--{ "<leader>a+", "<cmd>AiderQuickAddFile<cr>", desc = "Add File to Aider" },
		--{ "<leader>a-", "<cmd>AiderQuickDropFile<cr>", desc = "Drop File from Aider" },
		--{ "<leader>ar", "<cmd>AiderQuickReadOnlyFile<cr>", desc = "Add File as Read-Only" },
		---- Example nvim-tree.lua integration if needed
		--{ "<leader>a+", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
		--{ "<leader>a-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
	},
	dependencies = {
		"folke/snacks.nvim",
		"nvim-telescope/telescope.nvim",
		--- The below dependencies are optional
		"catppuccin/nvim",
	},
	config = function()
		local aider = require("nvim_aider")
		aider.setup(
			{
				defaults = {

				},
				setup = {

				},
				options = {

				},
				win = {
					height = 100,
				},
			}
		)
		local toggle_aider = function()
			vim.cmd("AiderTerminalToggle")
			vim.cmd("checktime")
		end
		vim.keymap.set(
			{ "n", "t" },
			"<M-a>",
			function()
				toggle_aider()
			end,
			{ noremap = true, silent = true }
		)
		vim.api.nvim_create_user_command(
			"RunTestInAider",
			function()
				-- get only the file name (without extention and path)
				local relative_path = vim.fn.expand('%:t:r')
				toggle_aider()
				vim.api.nvim_feedkeys("/test ./test.sh " .. relative_path, "n", false)
				vim.api.nvim_feedkeys("\r", "n", true)
			end,
			{}
		)
		vim.api.nvim_create_user_command(
			"WriteTestInAider",
			function()
				local relative_path = get_relative_path()
				toggle_aider()
				vim.api.nvim_feedkeys("write a test for the following file " .. relative_path, "n", false)
				vim.api.nvim_feedkeys("\r", "n", true)
			end,
			{}
		)
	end,
}
