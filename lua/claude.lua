-- Claude integration
local keymap_opts = {
	noremap = true,
	silent = true,
}

local claude_term_opts = {
	auto_close = false,
	win = { position = "float" },
}

-- Auto-create Claude terminal on startup using double toggle hack
local function create_claude_terminal()
	local snacks = require("snacks")
	-- First toggle to create and show
	snacks.terminal.toggle("claude", claude_term_opts)
	-- Second toggle to hide immediately without waiting
	snacks.terminal.toggle("claude", claude_term_opts)
	-- excape insert mode
	vim.cmd("stopinsert")
end

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

		-- First open the terminal
		snacks.terminal.toggle("claude", claude_term_opts)

		-- Give terminal time to initialize before sending commands
		vim.defer_fn(function()
			-- Just prepare the command in terminal for user to press Enter
			send_to_claude(string.format("! %s", filename))
			send_to_claude(string.format("./test.sh %s", filename))
		end, 100)
	end,
	{}
)

-- Add keymap for Claude terminal
vim.keymap.set(
	{ "n", "t" },
	"<F1>",
	function()
		local snacks = require("snacks")
		snacks.terminal.toggle("claude", claude_term_opts)
		vim.cmd("checktime")
	end,
	keymap_opts
)

-- Initialize Claude terminal on Vim startup
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		create_claude_terminal()
	end,
	group = vim.api.nvim_create_augroup("ClaudeTerminalInit", { clear = true }),
	desc = "Create Claude terminal on startup"
})

-- Call immediately for current session
create_claude_terminal()

return {
	send_to_claude = send_to_claude,
	claude_term_opts = claude_term_opts,
	create_claude_terminal = create_claude_terminal
}
