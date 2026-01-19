-- Search Highlighting Group
local search_highlight_group = vim.api.nvim_create_augroup("SearchHighlighting", { clear = true })
vim.api.nvim_create_autocmd("CmdlineEnter", {
	pattern = { "/", "?" },
	group = search_highlight_group,
	callback = function()
		vim.o.hlsearch = true
	end
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
	pattern = { "/", "?" },
	group = search_highlight_group,
	callback = function()
		vim.o.hlsearch = false
	end
})

-- General Settings Group
local general_group = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })
vim.api.nvim_create_autocmd("BufModifiedSet", {
	group = general_group,
	callback = function()
		vim.cmd("silent! w")
	end,
	desc = "Auto Save"
})

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
		end
	end,
})

-- Source local .nvim.lua configuration files
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		local local_lua_file = vim.fn.getcwd() .. "/.nvim.lua"
		if vim.fn.filereadable(local_lua_file) == 1 then
			vim.cmd("source " .. local_lua_file)
		end
	end,
	desc = "Source local .nvim.lua configuration files",
})

local mgrep_group = vim.api.nvim_create_augroup("MgrepWatch", { clear = true })

local function mgrep_is_running(jobid)
	if type(jobid) ~= "number" or jobid <= 0 then
		return false
	end
	return vim.fn.jobwait({ jobid }, 0)[1] == -1
end

local function start_mgrep_watch()
	if #vim.api.nvim_list_uis() == 0 then
		return
	end
	if vim.g.mgrep_watch_disable then
		return
	end
	if vim.fn.executable("mgrep") ~= 1 then
		return
	end
	if mgrep_is_running(vim.g.mgrep_watch_jobid) then
		return
	end

	local jobid = vim.fn.jobstart({ "mgrep", "watch" }, {
		cwd = vim.fn.getcwd(),
		stdout_buffered = false,
		stderr_buffered = false,
	})

	if jobid > 0 then
		vim.g.mgrep_watch_jobid = jobid
	end
end

local function stop_mgrep_watch()
	local jobid = vim.g.mgrep_watch_jobid
	if mgrep_is_running(jobid) then
		vim.fn.jobstop(jobid)
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	group = mgrep_group,
	callback = start_mgrep_watch,
	desc = "Start mgrep watch",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = mgrep_group,
	callback = stop_mgrep_watch,
	desc = "Stop mgrep watch",
})

