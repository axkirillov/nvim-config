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

-- Auto-save (safer than BufModifiedSet)
local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
	group = autosave_group,
	callback = function(args)
		local buf = args.buf
		-- Only for normal file buffers.
		if vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= "" then
			return
		end
		if not vim.api.nvim_get_option_value("modifiable", { buf = buf }) then
			return
		end
		if vim.api.nvim_get_option_value("readonly", { buf = buf }) then
			return
		end
		if not vim.api.nvim_get_option_value("modified", { buf = buf }) then
			return
		end
		if vim.api.nvim_buf_get_name(buf) == "" then
			return
		end

		pcall(function()
			vim.api.nvim_buf_call(buf, function()
				vim.cmd("silent! update")
			end)
		end)
	end,
	desc = "Auto-save on focus/leave",
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
