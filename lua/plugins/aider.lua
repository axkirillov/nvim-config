---@module "nvim_aider"
---@module 'snacks'

local M = {
	terminal = {},
	config = {
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
	},
}

local keymap_opts = {
	noremap = true,
	silent = true,
}

vim.keymap.set(
	{ "n", "t" },
	"<F1>",
	function()
		local terminal = require("nvim_aider.terminal")
		terminal.toggle()
		vim.cmd("checktime")
	end,
	keymap_opts
)

local function add_file(filepath, opts)
	opts = opts or {}
	local command = opts.readonly and "/read" or "/add"
	M.terminal.send(
		string.format("%s %s", command, filepath),
		M.config,
		false
	)
	M.terminal.toggle()
end

local function send(command)
	local terminal = require("nvim_aider.terminal")
	terminal.send(command, M.config, false)
	terminal.toggle()
end

return {
	"GeorgesAlkhouri/nvim-aider",
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
		M.terminal = require("nvim_aider.terminal")

		aider.setup(M.config)

		vim.api.nvim_create_user_command(
			"RunTestInAider",
			function()
				local filename = vim.fn.expand('%:t:r')
				local filepath = vim.fn.expand('%')
				add_file(filepath)
				send(string.format("/run ./test.sh %s", filename))
			end,
			{}
		)

		vim.api.nvim_create_user_command(
			"RunCestInAider",
			function()
				local filepath = vim.fn.expand('%')
				add_file(filepath)
				send(string.format("/run ./cest.sh %s", filepath))
			end,
			{}
		)

		vim.api.nvim_create_user_command(
			"WriteTestInAider",
			function()
				local filename = vim.fn.expand('%:t')
				add_file(vim.fn.expand('%'), { readonly = true })
				send(string.format("write a test for %s", filename))
			end,
			{}
		)

		vim.api.nvim_create_user_command(
			"RunPHPStanInAider",
			function()
				local relative_path = vim.fn.expand('%:.')
				add_file(vim.fn.expand('%'))
				send(string.format("/run ./stan.sh %s", relative_path))
			end,
			{}
		)

		vim.api.nvim_create_user_command(
			"PerformCodeReview",
			function()
				local default_branch = vim.fn.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5")
				vim.fn.system(string.format("git diff $(git merge-base HEAD %s ) > diff", default_branch))
				send("/read-only diff")
				send("perform code review")
			end,
			{}
		)

		vim.api.nvim_create_user_command(
			"AiderCommit",
			function()
				M.terminal.command("/commit")
			end,
			{}
		)

		vim.api.nvim_create_user_command(
			"AiderCreateClassUnderCursor",
			function()
				local class_name = vim.fn.expand("<cword>")
				send(string.format("/create class %s", class_name))
			end,
			{}
		)
	end,
}
