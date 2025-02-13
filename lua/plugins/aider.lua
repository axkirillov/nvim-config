---@module "nvim_aider"
---@module 'snacks'

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
		local terminal = require("nvim_aider.terminal")
		--local utils = require("nvim_aider.utils")

		local config = (
			{
				defaults = {

				},
				setup = {

				},
				options = {

				},
				---@type snacks.win.Config|{}
				win = {
					position = "float",
				},
			}
		)

		aider.setup(config)

		vim.api.nvim_create_autocmd("VimEnter", {
			group = vim.api.nvim_create_augroup("Aider", { clear = true }),
			callback = function()
				terminal.toggle()
				terminal.toggle()
			end
		})

		local keymap_opts = {
			noremap = true,
			silent = true,
		}

		vim.keymap.set(
			{ "n", "t" },
			"<F1>",
			function()
				terminal.toggle()
			end,
			keymap_opts
		)

		vim.api.nvim_create_user_command(
			"RunTestInAider",
			function()
				local relative_path = vim.fn.expand('%:t:r')
				vim.cmd("AiderQuickAddFile")
				terminal.send(
					"/run ./test.sh " .. relative_path,
					config,
					false
				)
				terminal.toggle()
			end,
			{}
		)

		vim.api.nvim_create_user_command(
			"WriteTestInAider",
			function()
				local filename = vim.fn.expand('%:t')
				vim.cmd("AiderQuickReadOnlyFile")
				terminal.send(
					"write a test for " .. filename,
					config,
					false
				)
				terminal.toggle()
			end,
			{}
		)

		vim.api.nvim_create_user_command(
			"RunPHPStanInAider",
			function()
				local full_path = vim.fn.expand('%:p')
				vim.cmd("AiderQuickAddFile")
				terminal.send(
					"/run make phpstan --" .. full_path,
					config,
					false
				)
				terminal.toggle()
			end,
			{}
		)
	end,
}
