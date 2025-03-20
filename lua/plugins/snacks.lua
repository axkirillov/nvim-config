local keymap_opts = {
	noremap = true,
	silent = true,
}

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
	config = function()
		local snacks = require("snacks")
		vim.keymap.set("n", "<C-g>", function() snacks.lazygit() end, keymap_opts)

		local claude_term_opts = {
			auto_close = false,
			win = { position = "float" },
		}
		vim.keymap.set(
			{ "n", "t" },
			"<F1>",
			function()
				snacks.terminal.toggle("claude", claude_term_opts)
				vim.cmd("checktime")
			end,
			keymap_opts
		)

		local function send_to_claude(text)
			local term = require("snacks.terminal").get("claude", claude_term_opts)

			if not term then
				vim.notify("Please open a Claude terminal first.", vim.log.levels.INFO)
				return
			end

			if term and term:buf_valid() then
				local chan = vim.api.nvim_buf_get_var(term.buf, "terminal_job_id")
				if chan then
					text = text:gsub("\n", " ") .. "\n"
					vim.api.nvim_chan_send(chan, text)
				else
					vim.notify("No Aider terminal job found!", vim.log.levels.ERROR)
				end
			else
				vim.notify("Please open an Aider terminal first.", vim.log.levels.INFO)
			end
		end

		vim.api.nvim_create_user_command(
			"RunTestInClaude",
			function()
				local filename = vim.fn.expand('%:t:r')
				local filepath = vim.fn.expand('%')
				send_to_claude(string.format("!", filename))
				send_to_claude(string.format(" ./test.sh %s", filename))
				snacks.terminal.toggle("claude", claude_term_opts)
			end,
			{}
		)

		vim.keymap.set(
			{ "n", "t" },
			"<F2>",
			function()
				snacks.terminal.toggle(
					nil,
					{
						auto_close = false,
						win = { position = "float" },
					}
				)
				vim.cmd("checktime")
			end,
			keymap_opts
		)
	end
}
