---@module "nvim_aider"
---@module 'snacks'

local M = {
	terminal = {},
	terminal_config = {
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

local function add_file(filepath, opts)
	opts = opts or {}
	local command = opts.readonly and "/read" or "/add"
	M.terminal.send(
		string.format("%s %s", command, filepath),
		M.terminal_config,
		false
	)
end

local function send(command)
	M.terminal.send(command, M.terminal_config, false)
	M.terminal.toggle()
end

return {
	"GeorgesAlkhouri/nvim-aider",
	dependencies = {
		"folke/snacks.nvim",
		"nvim-telescope/telescope.nvim",
		--- The below dependencies are optional
		"catppuccin/nvim",
	},
	config = function()
		local aider = require("nvim_aider")
		M.terminal = require("nvim_aider.terminal")
		vim.keymap.set(
			{ "n", "t" },
			"<F3>",
			function()
				M.terminal.toggle()
				vim.cmd("checktime")
			end,
			keymap_opts
		)

		-- start on vim startup
		--vim.api.nvim_create_autocmd(
		--	"VimEnter",
		--	{
		--		callback = function()
		--			M.terminal.toggle()
		--			M.terminal.toggle()
		--			vim.cmd("stopinsert")
		--		end
		--	}
		--)

		aider.setup(M.terminal_config)

		--vim.api.nvim_create_user_command(
		--	"RunTestInAider",
		--	function()
		--		local filename = vim.fn.expand('%:t:r')
		--		local filepath = vim.fn.expand('%')
		--		add_file(filepath)
		--		send(string.format("/run ./test.sh %s", filename))
		--	end,
		--	{}
		--)

		--vim.api.nvim_create_user_command(
		--	"RunTest",
		--	function()
		--		local filename = vim.fn.expand('%:t:r')
		--		local filepath = vim.fn.expand('%')
		--		add_file(filepath)
		--		send(string.format("/run ./test.sh %s", filename))
		--	end,
		--	{}
		--)

		--vim.api.nvim_create_user_command(
		--	"RunCestInAider",
		--	function()
		--		local filepath = vim.fn.expand('%')
		--		add_file(filepath)
		--		send(string.format("/run ./cest.sh %s", filepath))
		--	end,
		--	{}
		--)

		--vim.api.nvim_create_user_command(
		--	"WriteTestInAider",
		--	function()
		--		local filename = vim.fn.expand('%:t')
		--		add_file(vim.fn.expand('%'), { readonly = true })
		--		send(string.format("write a test for %s", filename))
		--	end,
		--	{}
		--)

		--vim.api.nvim_create_user_command(
		--	"RunPHPStanInAider",
		--	function()
		--		local relative_path = vim.fn.expand('%:.')
		--		add_file(vim.fn.expand('%'))
		--		send(string.format("/run ./stan.sh %s", relative_path))
		--	end,
		--	{}
		--)

		--vim.api.nvim_create_user_command(
		--	"PerformCodeReview",
		--	function()
		--		local default_branch = vim.fn.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5")
		--		vim.fn.system(string.format("git diff $(git merge-base HEAD %s ) > diff", default_branch))
		--		send("/read-only diff")
		--		send("perform code review")
		--	end,
		--	{}
		--)

		--vim.api.nvim_create_user_command(
		--	"AiderRunPreCommitHook",
		--	function()
		--		send("/run .git/hooks/pre-commit")
		--	end,
		--	{}
		--)

		--vim.api.nvim_create_user_command(
		--	"AiderRunPrePushHook",
		--	function()
		--		send("/run .git/hooks/pre-push")
		--	end,
		--	{}
		--)

		--vim.api.nvim_create_user_command(
		--	"AiderCreateClassUnderCursor",
		--	function()
		--		local class_name = vim.fn.expand("<cword>")
		--		send(string.format("/create class %s", class_name))
		--	end,
		--	{}
		--)
	end,
}
