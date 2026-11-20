local function open_lazygit()
	vim.cmd("tabnew")
	vim.fn.jobstart({ "lazygit" }, {
		term = true,
		on_exit = function()
			vim.schedule(function()
				vim.cmd("silent! bwipeout!")
				vim.cmd("checktime")
			end)
		end,
	})
	vim.cmd("startinsert")
end

vim.keymap.set({ "n", "t" }, "<C-g>", open_lazygit, { silent = true, desc = "Lazygit" })
