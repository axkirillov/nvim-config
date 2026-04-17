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

local function is_pi_terminal(term)
	return term.cmd and type(term.cmd) == "string"
		and (term.cmd == "pi" or term.cmd:match("^pi "))
end

---@param win snacks.win
---@param opts? { keep?: fun(term: snacks.win): boolean }
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

local function close_pi_terminals()
	for _, term in pairs(require("snacks").terminal.list()) do
		if is_pi_terminal(term) then
			term:close()
		end
	end
end

local function close_claude_terminals()
	for _, term in pairs(require("snacks").terminal.list()) do
		if term.cmd and type(term.cmd) == "string"
			and (term.cmd == "claude" or term.cmd:match("^claude ")) then
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
		local claude_opts = {
			auto_close = false,
			win = { position = "right" },
		}
		-- Close any claude session terminals before toggling default claude
		for _, term in pairs(snacks.terminal.list()) do
			if term.cmd and type(term.cmd) == "string" and term.cmd:match("^claude ") then
				term:close()
			end
		end
		local win = snacks.terminal.toggle("claude --effort max", claude_opts)
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
		local win = snacks.terminal.toggle(nil, term_opts)
		close_other_terminals(win, { keep = is_pi_terminal })
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

	local cwd = vim.fn.getcwd()

	local py = [=[
import json, os, glob, sys, subprocess

def get_repo_root(cwd: str):
    try:
        out = subprocess.check_output(["git", "-C", cwd, "rev-parse", "--show-toplevel"], stderr=subprocess.STDOUT)
        root = out.decode().strip()
        return root if root else None
    except Exception:
        return None

base = os.path.expanduser('~/.pi/agent/sessions')
input_cwd = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
repo_root = get_repo_root(input_cwd)

results, seen = [], set()
for path in glob.glob(os.path.join(base, '*', '*.jsonl')):
    ino = os.stat(path).st_ino
    if ino in seen: continue
    seen.add(ino)
    ts, name, first_user, hcwd = '', '', '', ''
    try:
        with open(path) as f:
            h = json.loads(f.readline())
            ts, hcwd = h.get('timestamp', ''), h.get('cwd', '')
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
                                    if isinstance(i, dict) and i.get('type') == 'text':
                                        first_user = str(i.get('text', ''))[:80].replace('\n', ' ').replace('\t', ' ')
                                        break
                            elif isinstance(c, str):
                                first_user = c[:80].replace('\n', ' ').replace('\t', ' ')
                    except: pass
    except: continue
    # Filter by repo root when available
    if repo_root:
        if not (hcwd == repo_root or (isinstance(hcwd, str) and hcwd.startswith(repo_root + os.sep))):
            continue
    display = name or first_user or '(unnamed)'
    project = os.path.basename(hcwd) if hcwd else '?'
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

	fzf_lua.fzf_exec("python3 " .. tmp .. " " .. vim.fn.shellescape(cwd), {
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

local function claude_session_picker()
	local fzf_lua = require("fzf-lua")

	local cwd = vim.fn.getcwd()
	local project_key = cwd:gsub("[^%w%-]", "-")
	local project_dir = os.getenv("HOME") .. "/.claude/projects/" .. project_key

	local py = string.format([=[
import json, os, glob, sys

project_dir = sys.argv[1]
sessions_dir = os.path.expanduser('~/.claude/sessions')

if not os.path.isdir(project_dir):
    sys.exit(0)

meta = {}
for f in glob.glob(os.path.join(sessions_dir, '*.json')):
    try:
        with open(f) as fh:
            d = json.load(fh)
            meta[d['sessionId']] = d
    except: pass

results = []
for jsonl in glob.glob(os.path.join(project_dir, '*.jsonl')):
    sid = os.path.splitext(os.path.basename(jsonl))[0]
    m = meta.get(sid, {})
    started = m.get('startedAt', 0)
    first_user = ''
    summary = ''
    ts = ''
    try:
        with open(jsonl) as fh:
            for line in fh:
                if not first_user and '"role":"user"' in line:
                    try:
                        e = json.loads(line)
                        msg = e.get('message', {})
                        if msg.get('role') == 'user':
                            c = msg.get('content', '')
                            if isinstance(c, list):
                                for i in c:
                                    if i.get('type') == 'text':
                                        first_user = i['text'][:100].replace('\n', ' ').replace('\t', ' ')
                                        break
                            elif isinstance(c, str):
                                first_user = c[:100].replace('\n', ' ').replace('\t', ' ')
                            if not ts:
                                ts = e.get('timestamp', '')
                    except: pass
                if not summary and '"type":"summary"' in line:
                    try:
                        e = json.loads(line)
                        if e.get('type') == 'summary':
                            summary = e.get('summary', '')[:100].replace('\n', ' ').replace('\t', ' ')
                    except: pass
                if first_user and summary: break
    except: continue
    display = summary or first_user or '(empty)'
    if ts and len(ts) > 16:
        d = ts[:10] + ' ' + ts[11:16]
    elif started:
        from datetime import datetime
        dt = datetime.fromtimestamp(started / 1000)
        d = dt.strftime('%%Y-%%m-%%d %%H:%%M')
    else:
        d = '?'
    sort_key = ts or (str(started) if started else '')
    results.append((sort_key, f'{display}\t{d}\t{sid}'))
results.sort(reverse=True)
for r in results: print(r[1])
]=])

	local tmp = "/tmp/_nvim_claude_sessions.py"
	local f = io.open(tmp, "w")
	if not f then
		vim.notify("Failed to write session helper", vim.log.levels.ERROR)
		return
	end
	f:write(py)
	f:close()

	local cmd = "{ printf '+ New session\\t\\tnew\\n'; python3 "
		.. tmp .. " " .. vim.fn.shellescape(project_dir) .. "; }"
	fzf_lua.fzf_exec(cmd, {
		prompt = "Claude Sessions> ",
		fzf_opts = {
			["--delimiter"] = "\t",
			["--with-nth"] = "1..2",
			["--nth"] = "1",
			["--no-sort"] = "",
		},
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then return end
				local sid = vim.trim(vim.split(selected[1], "\t")[3])
				close_claude_terminals()
				local snacks = require("snacks")
				local cmd_str = sid == "new"
					and "claude --effort max"
					or ("claude --effort max --resume " .. sid)
				local win = snacks.terminal.toggle(
					cmd_str,
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

vim.keymap.set({ "n", "t" }, "<C-s>", claude_session_picker, keymap_opts)

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
