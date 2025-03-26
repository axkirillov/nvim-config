-- Claude integration
local keymap_opts = {
	noremap = true,
	silent = true,
}

local claude_term_opts = {
	auto_close = false,
	win = { position = "float" },
}

local function send_to_claude(text)
	local term = require("snacks.terminal").get("claude", claude_term_opts)

	if not term then
		vim.notify("Please open a Claude terminal first.", vim.log.levels.INFO)
		return
	end

	if term and term:buf_valid() then
		local chan = vim.api.nvim_buf_get_var(term.buf, "terminal_job_id")
		if chan then
			text = text:gsub("\n", " ")
			vim.api.nvim_chan_send(chan, text)
		else
			vim.notify("No Claude terminal job found!", vim.log.levels.ERROR)
		end
	else
		vim.notify("Please open a Claude terminal first.", vim.log.levels.INFO)
	end
end

-- Create command to run tests in Claude
vim.api.nvim_create_user_command(
	"RunTestInClaude",
	function()
		local snacks = require("snacks")
		local filename = vim.fn.expand('%:t:r')

		snacks.terminal.toggle("claude", claude_term_opts)

		send_to_claude(string.format("! %s", filename))
		vim.defer_fn(function()
			-- Just prepare the command in terminal for user to press Enter
			send_to_claude(string.format("./test.sh %s", filename))
		end, 100)
	end,
	{}
)

-- Create command to run make phpstan
vim.api.nvim_create_user_command(
	"RunMakePhpstan",
	function()
		local snacks = require("snacks")

		snacks.terminal.toggle("claude", claude_term_opts)

		vim.defer_fn(function()
			send_to_claude("!")
			send_to_claude(string.format("make phpstan"))
		end, 100)
	end,
	{}
)

-- remap c-j to enter in terminal insert mode
vim.keymap.set("i", "<C-j>", "<CR>", keymap_opts)

-- Add keymap for Claude terminal
vim.keymap.set(
	{ "n", "t" },
	"<F1>",
	function()
		local snacks = require("snacks")
		-- close all other teminals
		snacks.terminal.toggle("claude", claude_term_opts)
		vim.cmd("checktime")
	end,
	keymap_opts
)

return {
	send_to_claude = send_to_claude,
	claude_term_opts = claude_term_opts,
}
