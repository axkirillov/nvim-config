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

local function is_claude_terminal(term)
	return term.cmd and type(term.cmd) == "string"
		and (term.cmd == "claude" or term.cmd:match("^claude "))
end

local function git_main_root()
	local cwd = vim.fn.getcwd()
	local out = vim.fn.systemlist({
		"git", "-C", cwd, "rev-parse", "--path-format=absolute", "--git-common-dir",
	})
	if vim.v.shell_error ~= 0 or #out == 0 or out[1] == "" then
		return cwd
	end
	local root = out[1]:gsub("/%.git/?$", "")
	return root ~= "" and root or cwd
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

local function close_pi_terminals()
	for _, term in pairs(require("snacks").terminal.list()) do
		if is_pi_terminal(term) then
			term:close()
		end
	end
end

local function close_claude_terminals()
	for _, term in pairs(require("snacks").terminal.list()) do
		if is_claude_terminal(term) then
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

local function composer_prompt_suffix()
	local msg = vim.env.COMPOSER_MESSAGE
	if not msg or msg == "" then
		return ""
	end
	vim.env.COMPOSER_MESSAGE = nil
	if vim.env.TMUX then
		vim.fn.system({ "tmux", "set-environment", "-u", "COMPOSER_MESSAGE" })
	end
	return " " .. vim.fn.shellescape(msg)
end

local composer_allowed_flags = { effort = true, model = true, thinking = true, provider = true }

local function composer_flag_value_ok(value)
	if not value or not value:match("^[%w_:%-%.%[%]/]+$") then
		return false
	end
	if value:find("%.%.") or value:sub(1, 1) == "/" or value:sub(-1) == "/" then
		return false
	end
	return select(2, value:gsub("/", "")) <= 1
end

local function composer_flags_suffix(var)
	local raw = vim.env[var]
	if not raw or raw == "" then
		return ""
	end
	vim.env[var] = nil
	if vim.env.TMUX then
		vim.fn.system({ "tmux", "set-environment", "-u", var })
	end
	local words = vim.split(vim.trim(raw), "%s+")
	local kept = {}
	local i = 1
	while i < #words do
		local name = words[i]:match("^%-%-([a-z]+)$")
		local value = words[i + 1]
		if name and composer_allowed_flags[name] and composer_flag_value_ok(value) then
			kept[#kept + 1] = words[i]
			kept[#kept + 1] = vim.fn.shellescape(value)
			i = i + 2
		else
			i = i + 1
		end
	end
	if #kept == 0 then
		return ""
	end
	return " " .. table.concat(kept, " ")
end

local claude_sessions_dir = vim.fn.stdpath("state") .. "/claude-windows"

local function claude_window_key()
	local pane = vim.env.TMUX_PANE
	if not pane or pane == "" then
		return nil
	end
	local out = vim.fn.systemlist({
		"tmux", "display-message", "-p", "-t", pane, "#{session_name}:#{window_index}",
	})
	if vim.v.shell_error ~= 0 or #out == 0 or out[1] == "" then
		return nil
	end
	return out[1]
end

local function claude_session_file(key)
	return claude_sessions_dir .. "/" .. key:gsub("[^%w%-]", "_")
end

local function record_window_session(sid)
	if not sid or sid == "" then
		return
	end
	local key = claude_window_key()
	if not key then
		return
	end
	vim.fn.mkdir(claude_sessions_dir, "p")
	local f = io.open(claude_session_file(key), "w")
	if f then
		f:write(sid)
		f:close()
	end
end

local function lookup_window_session()
	local key = claude_window_key()
	if not key then
		return nil
	end
	local f = io.open(claude_session_file(key), "r")
	if not f then
		return nil
	end
	local sid = vim.trim(f:read("*a") or "")
	f:close()
	return sid ~= "" and sid or nil
end

local function new_session_id()
	local out = vim.fn.systemlist({ "uuidgen" })
	if vim.v.shell_error ~= 0 or #out == 0 then
		return nil
	end
	return vim.trim(out[1]):lower()
end

local function open_claude()
	local snacks = require("snacks")
	local existing
	for _, term in pairs(snacks.terminal.list()) do
		if is_claude_terminal(term) then
			if not existing then
				existing = term
			else
				term:close()
			end
		end
	end
	local win
	if existing then
		if existing.win and vim.api.nvim_win_is_valid(existing.win) then
			existing:hide()
		else
			existing:show()
		end
		win = existing
	else
		local sid = new_session_id()
		record_window_session(sid)
		local id_arg = sid and (" --session-id " .. sid) or ""
		win = snacks.terminal.toggle("claude" .. id_arg .. composer_flags_suffix("COMPOSER_CLAUDE_FLAGS") .. composer_prompt_suffix(), {
			auto_close = false,
			win = { position = "right", width = 0.5 },
		})
	end
	close_other_terminals(win)
	vim.cmd("checktime")
end

vim.keymap.set({ "n", "t" }, "<F1>", open_claude, keymap_opts)

vim.api.nvim_create_user_command("Claude", function()
	vim.defer_fn(open_claude, 100)
end, {})

local function open_pi()
	local snacks = require("snacks")
	local existing
	for _, term in pairs(snacks.terminal.list()) do
		if is_pi_terminal(term) then
			if not existing then
				existing = term
			else
				term:close()
			end
		end
	end
	local win
	if existing then
		if existing.win and vim.api.nvim_win_is_valid(existing.win) then
			existing:hide()
		else
			existing:show()
		end
		win = existing
	else
		win = snacks.terminal.toggle("pi" .. composer_flags_suffix("COMPOSER_PI_FLAGS") .. composer_prompt_suffix(), {
			auto_close = false,
			win = { position = "right", width = 0.5 },
		})
	end
	close_other_terminals(win)
	vim.cmd("checktime")
end

vim.api.nvim_create_user_command("Pi", function()
	vim.defer_fn(open_pi, 100)
end, {})

vim.api.nvim_create_user_command("PiResume", function(opts)
	local session = opts.args
	if session == "" then
		vim.notify("PiResume: missing session (path or id)", vim.log.levels.ERROR)
		return
	end
	vim.defer_fn(function()
		local snacks = require("snacks")
		local win = snacks.terminal.toggle(
			"pi --session " .. vim.fn.shellescape(session) .. composer_flags_suffix("COMPOSER_PI_FLAGS") .. composer_prompt_suffix(), {
				auto_close = false,
				win = { position = "right", width = 0.5 },
			})
		close_other_terminals(win)
	end, 100)
end, { nargs = 1 })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.env.RESURRECT_RESTORING ~= "1" then
			return
		end
		local sid = lookup_window_session()
		if not sid then
			return
		end
		local project_key = vim.fn.getcwd():gsub("[^%w%-]", "-")
		local transcript = os.getenv("HOME") .. "/.claude/projects/" .. project_key .. "/" .. sid .. ".jsonl"
		if vim.fn.filereadable(transcript) == 0 then
			return
		end
		vim.defer_fn(function()
			local snacks = require("snacks")
			local win = snacks.terminal.toggle(
				"claude --resume " .. vim.fn.shellescape(sid), {
					auto_close = false,
					win = { position = "right", width = 0.5 },
				})
			close_other_terminals(win)
		end, 100)
	end,
})

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

	local main_root = git_main_root()
	local project_key = main_root:gsub("[^%w%-]", "-")
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
    live_name = m.get('name', '') or ''
    agent_name = ''
    ai_title = ''
    first_user = ''
    summary = ''
    ts = ''
    try:
        with open(jsonl) as fh:
            for line in fh:
                if '"type":"agent-name"' in line:
                    try:
                        e = json.loads(line)
                        if e.get('type') == 'agent-name':
                            v = e.get('agentName', '') or ''
                            if v: agent_name = v
                    except: pass
                if '"type":"ai-title"' in line:
                    try:
                        e = json.loads(line)
                        if e.get('type') == 'ai-title':
                            v = e.get('aiTitle', '') or ''
                            if v: ai_title = v
                    except: pass
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
    except: continue
    display = agent_name or live_name or ai_title or summary or first_user or '(empty)'
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
				local cmd_str
				if sid == "new" then
					local newid = new_session_id()
					record_window_session(newid)
					cmd_str = "claude" .. (newid and (" --session-id " .. newid) or "")
				else
					record_window_session(sid)
					cmd_str = "claude --resume " .. vim.fn.shellescape(sid)
				end
				local win = snacks.terminal.toggle(
					cmd_str,
					{ auto_close = false, win = { position = "right", width = 0.5 } }
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

vim.api.nvim_create_user_command("ClaudeResume", function(opts)
	local sid = opts.fargs[1]
	if not sid or sid == "" then
		vim.notify("ClaudeResume: missing session id", vim.log.levels.ERROR)
		return
	end
	local flags = ""
	for i = 2, #opts.fargs do
		flags = flags .. " " .. vim.fn.shellescape(opts.fargs[i])
	end
	record_window_session(sid)
	close_claude_terminals()
	vim.defer_fn(function()
		local snacks = require("snacks")
		local win = snacks.terminal.toggle(
			"claude --resume " .. vim.fn.shellescape(sid) .. flags
			.. composer_flags_suffix("COMPOSER_CLAUDE_FLAGS") .. composer_prompt_suffix(), {
				auto_close = false,
				win = { position = "right", width = 0.5 },
			})
		close_other_terminals(win)
	end, 100)
end, { nargs = "+" })

vim.api.nvim_create_user_command("ClaudeSend", function(opts)
	local path = opts.args
	if path == "" then
		vim.notify("ClaudeSend: missing message file path", vim.log.levels.ERROR)
		return
	end
	local ok, lines = pcall(vim.fn.readfile, path)
	vim.fn.delete(path)
	if not ok or type(lines) ~= "table" or #lines == 0 then
		vim.notify("ClaudeSend: empty or unreadable message file", vim.log.levels.ERROR)
		return
	end
	local message = table.concat(lines, " ")
	local target
	for _, term in pairs(require("snacks").terminal.list()) do
		if is_claude_terminal(term) and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
			target = term
			break
		end
	end
	if not target then
		vim.notify("ClaudeSend: no claude terminal in this nvim", vim.log.levels.ERROR)
		return
	end
	local chan = vim.api.nvim_buf_get_var(target.buf, "terminal_job_id")
	if chan then
		vim.api.nvim_chan_send(chan, message)
		vim.defer_fn(function()
			vim.api.nvim_chan_send(chan, "\r")
		end, 200)
	else
		vim.notify("ClaudeSend: claude terminal has no job channel", vim.log.levels.ERROR)
	end
end, { nargs = 1 })

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
