local keymap_opts = {
	noremap = true,
	silent = true,
}

local term_opts = {
	auto_close = false,
	win = { position = "right" },
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
			-- Ensure the command is executed.
			vim.api.nvim_chan_send(chan, text .. "\n")
		else
			vim.notify("No terminal job found!", vim.log.levels.ERROR)
		end
	else
		vim.notify("Please open a terminal first.", vim.log.levels.INFO)
	end
end

---@param win snacks.win
local function close_other_terminals(win)
	local snacks = require("snacks")
	local terminals = snacks.terminal.list()
	for _, term in pairs(terminals) do
		if term.buf ~= win.buf then
			term:hide()
		end
	end
end

local function close_pi_terminals()
	for _, term in pairs(require("snacks").terminal.list()) do
		if term.cmd and type(term.cmd) == "string"
			and (term.cmd == "pi" or term.cmd:match("^pi ")) then
			term:close()
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

vim.keymap.set(
	{ "n", "t" },
	"<F1>",
	function()
		local snacks = require("snacks")
		local pi_opts = {
			auto_close = false,
			win = { position = "right" },
		}
		-- Close any pi session terminals before toggling default pi
		for _, term in pairs(snacks.terminal.list()) do
			if term.cmd and type(term.cmd) == "string" and term.cmd:match("^pi ") then
				term:close()
			end
		end
		local win = snacks.terminal.toggle("pi", pi_opts)
		close_other_terminals(win)
		vim.cmd("checktime")
	end,
	keymap_opts
)

vim.keymap.set(
	{ "n", "t" },
	"<F2>",
	function()
		local snacks = require("snacks")
		snacks.terminal.toggle(nil, term_opts)
		vim.cmd("checktime")
	end,
	keymap_opts
)

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



-- Pi session picker
local function pi_session_picker()
	local fzf_lua = require("fzf-lua")

	local py = [=[
import json, os, glob
base = os.path.expanduser('~/.pi/agent/sessions')
results, seen = [], set()
for path in glob.glob(os.path.join(base, '*', '*.jsonl')):
    ino = os.stat(path).st_ino
    if ino in seen: continue
    seen.add(ino)
    ts, name, first_user, cwd = '', '', '', ''
    try:
        with open(path) as f:
            h = json.loads(f.readline())
            ts, cwd = h.get('timestamp', ''), h.get('cwd', '')
            for line in f:
                if '"session_info"' in line:
                    try:
                        e = json.loads(line)
                        if e.get('type') == 'session_info': name = e.get('name', '')
                    except: pass
                elif not first_user and '"role":"user"' in line:
                    try:
                        e = json.loads(line)
                        m = e.get('message', {})
                        if m.get('role') == 'user':
                            c = m.get('content', '')
                            if isinstance(c, list):
                                for i in c:
                                    if i.get('type') == 'text':
                                        first_user = i['text'][:80].replace('\n', ' ').replace('\t', ' ')
                                        break
                            elif isinstance(c, str): first_user = c[:80].replace('\n', ' ').replace('\t', ' ')
                    except: pass
    except: continue
    display = name or first_user or '(unnamed)'
    project = os.path.basename(cwd) if cwd else '?'
    d = (ts[:10] + ' ' + ts[11:16]) if len(ts) > 16 else '?'
    results.append((ts, f'{display}\t{project}\t{d}\t{path}'))
results.sort(reverse=True)
for r in results: print(r[1])
]=]

	local tmp = "/tmp/_nvim_pi_sessions.py"
	local f = io.open(tmp, "w")
	if not f then
		vim.notify("Failed to write session helper", vim.log.levels.ERROR)
		return
	end
	f:write(py)
	f:close()

	fzf_lua.fzf_exec("python3 " .. tmp, {
		prompt = "Pi Sessions❯ ",
		fzf_opts = {
			["--delimiter"] = "\t",
			["--with-nth"] = "1..3",
			["--nth"] = "1,2",
			["--no-sort"] = "",
		},
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then return end
				local session_path = vim.trim(vim.split(selected[1], "\t")[4])
				close_pi_terminals()
				local snacks = require("snacks")
				local win = snacks.terminal.toggle(
					"pi --session " .. vim.fn.shellescape(session_path),
					{ auto_close = false, win = { position = "right" } }
				)
				close_other_terminals(win)
				vim.cmd("checktime")
			end,
		},
		winopts = {
			height = 0.6,
			width = 0.8,
		},
	})
end

vim.keymap.set({ "n", "t" }, "<C-s>", pi_session_picker, keymap_opts)

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
		},
		input = {
		},
		picker = {
		},
	},
}
