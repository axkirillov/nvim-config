local keymap_opts = {
	noremap = true,
	silent = true,
}

local term_opts = {
	auto_close = false,
	win = { position = "right", width = 0.5 },
}

local function send_to_terminal(text)
	local term = require("snacks.terminal").get(nil, term_opts)

	if not term then
		vim.notify("Please open a terminal first.", vim.log.levels.INFO)
		return
	end

	if term and term:buf_valid() then
		local chan = vim.api.nvim_buf_get_var(term.buf, "terminal_job_id")
		if chan then
			text = text:gsub("\n", " ")
			vim.api.nvim_chan_send(chan, text .. "\n")
		else
			vim.notify("No terminal job found!", vim.log.levels.ERROR)
		end
	else
		vim.notify("Please open a terminal first.", vim.log.levels.INFO)
	end
end

local function is_pi_terminal(term)
	return term.cmd and type(term.cmd) == "string"
		and (term.cmd == "pi" or term.cmd:match("^pi "))
end

local function close_other_terminals(win, opts)
	opts = opts or {}
	local snacks = require("snacks")
	local terminals = snacks.terminal.list()
	for _, term in pairs(terminals) do
		if term.buf ~= win.buf and not (opts.keep and opts.keep(term)) then
			term:hide()
		end
	end
end

vim.keymap.set(
	{ "n", "t" },
	"<C-g>",
	function()
		local snacks = require("snacks")
		snacks.lazygit()
	end,
	keymap_opts
)

local function open_terminal()
	local snacks = require("snacks")
	snacks.terminal.toggle(nil, {
		auto_close = false,
		win = { position = "right", width = 0.5 },
	})
end

vim.keymap.set({ "n", "t" }, "<F1>", open_terminal, keymap_opts)

vim.keymap.set(
	{ "n", "t" },
	"<F2>",
	function()
		local snacks = require("snacks")
		local win = snacks.terminal.toggle(nil, term_opts)
		close_other_terminals(win, { keep = is_pi_terminal })
		vim.cmd("checktime")
	end,
	keymap_opts
)

local quiz_cmd = vim.fn.expand("~/go/bin/all-in-quiz")
	.. " --decks "
	.. vim.fn.expand("~/repos/axkirillov/all-in-quiz/decks")
local quiz_opts = {
	auto_close = false,
	win = { position = "float", width = 0.8, height = 0.8, border = "rounded" },
}

local function quiz_running(term)
	if not (term and term:buf_valid()) then
		return false
	end
	local ok, chan = pcall(vim.api.nvim_buf_get_var, term.buf, "terminal_job_id")
	return ok and type(chan) == "number" and vim.fn.jobwait({ chan }, 0)[1] == -1
end

local function open_quiz()
	local snacks_term = require("snacks").terminal
	local existing
	for _, term in pairs(snacks_term.list()) do
		if term.cmd == quiz_cmd then
			existing = term
			break
		end
	end
	if quiz_running(existing) then
		existing:toggle()
	else
		if existing then
			existing:close()
		end
		snacks_term.open(quiz_cmd, quiz_opts)
	end
end

vim.keymap.set({ "n", "t" }, "<F3>", open_quiz, keymap_opts)

vim.api.nvim_create_user_command(
	"RunTestInTerminal",
	function()
		local snacks = require("snacks")
		local filename = vim.fn.expand('%:t:r')

		snacks.terminal.toggle(nil, term_opts)

		send_to_terminal(string.format("./test.sh %s", filename))
	end,
	{}
)

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
			win = { keys = { term_normal = false } },
		},
		input = {
		},
		picker = {
		},
	},
}
