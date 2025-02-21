return {
	"hedyhli/outline.nvim",
	config = function()
		-- Example mapping to toggle outline
		local keymap_opts = { desc = "Toggle Outline" }
		vim.keymap.set(
			"n",
			"<C-h>",
			"<cmd>OutlineFocus<CR>",
			keymap_opts
		)

		local outline = require("outline")

		-- open on vim start
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				outline.open()
				outline.focus_code()
			end
		})

		require("outline").setup {
			outline_window = {
				auto_jump = true,
				auto_close = true,
				focus_on_open = true,
				width = 15,
				position = 'left',
			},
			outline_items = {
				show_symbol_details = false,
			},
			keymaps = {
				goto_location = '<C-j>',
			},
		}

		vim.api.nvim_create_autocmd("WinClosed", {
			callback = function()
				vim.schedule(function()
					local wins = vim.api.nvim_list_wins()
					local non_floating_wins = {}
					for _, win in ipairs(wins) do
						local config = vim.api.nvim_win_get_config(win)
						-- Only consider non-floating windows.
						if config.relative == "" then
							table.insert(non_floating_wins, win)
						end
					end
					if #non_floating_wins == 1 then
						local win = non_floating_wins[1]
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].filetype == "Outline" then
							vim.cmd("q")
						end
					end
				end)
			end,
		})
	end,
}
