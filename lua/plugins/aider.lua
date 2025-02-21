---@module "nvim_aider"
---@module 'snacks'

return {
	"GeorgesAlkhouri/nvim-aider",
	lazy = false,
	keys = {
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

		local keymap_opts = {
			noremap = true,
			silent = true,
		}

		vim.keymap.set(
			{ "n", "t" },
			"<F1>",
			function()
				terminal.toggle()
				vim.cmd("checktime")
			end,
			keymap_opts
		)

		vim.api.nvim_create_user_command(
			"RunTestInAider",
			function()
				local filename = vim.fn.expand('%:t:r')
				vim.cmd("AiderQuickAddFile")
				terminal.send(
					"/run ./test.sh " .. filename,
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
				local relative_path = vim.fn.expand('%:.')
				vim.cmd("AiderQuickAddFile")
				terminal.send(
					"/run ./stan.sh " .. relative_path,
					config,
					false
				)
				terminal.toggle()
			end,
			{}
		)
	end,
}
