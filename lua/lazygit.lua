local function close_lazygit_tab(origin_tab, tab, lazygit_buf)
	local win = vim.api.nvim_tabpage_is_valid(tab) and vim.api.nvim_tabpage_get_win(tab)
	local edited_buf = win and vim.api.nvim_win_get_buf(win)
	local edited_cursor = win and vim.api.nvim_win_get_cursor(win)

	if vim.api.nvim_buf_is_valid(lazygit_buf) then
		vim.api.nvim_buf_delete(lazygit_buf, { force = true })
	end

	if edited_buf and edited_buf ~= lazygit_buf and vim.api.nvim_tabpage_is_valid(tab) then
		vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(tab))
		if vim.api.nvim_tabpage_is_valid(origin_tab) then
			vim.api.nvim_set_current_tabpage(origin_tab)
		end
		vim.api.nvim_set_current_buf(edited_buf)
		pcall(vim.api.nvim_win_set_cursor, 0, edited_cursor)
	end

	vim.cmd("checktime")
end

local function open_lazygit()
	local origin_tab = vim.api.nvim_get_current_tabpage()
	vim.cmd("tabnew")
	local tab = vim.api.nvim_get_current_tabpage()
	local lazygit_buf = vim.api.nvim_get_current_buf()
	local job = vim.fn.jobstart({ "lazygit" }, {
		term = true,
		on_exit = function()
			vim.schedule(function()
				close_lazygit_tab(origin_tab, tab, lazygit_buf)
			end)
		end,
	})
	vim.api.nvim_create_autocmd("BufHidden", {
		buffer = lazygit_buf,
		once = true,
		callback = function()
			vim.schedule(function()
				vim.fn.jobstop(job)
			end)
		end,
	})
	vim.cmd("startinsert")
end

vim.keymap.set({ "n", "t" }, "<C-g>", open_lazygit, { silent = true, desc = "Lazygit" })
