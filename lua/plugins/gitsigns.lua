return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require('gitsigns')
		gitsigns.setup()
		vim.api.nvim_create_user_command(
			"ToggleGit",
			function()
				gitsigns.toggle_linehl()
				gitsigns.toggle_numhl()
				gitsigns.toggle_deleted()
			end,
			{}
		)

		vim.keymap.set('n', ']g', function()
			if vim.wo.diff then
				vim.cmd.normal({ ']c', bang = true })
			else
				gitsigns.nav_hunk('next')
			end
		end)

		vim.keymap.set(
			'n',
			'[g',
			function()
				if vim.wo.diff then
					vim.cmd.normal({ '[c', bang = true })
				else
					gitsigns.nav_hunk('prev')
				end
			end,
			{}
		)

		vim.keymap.set('n', '<leader>hi', gitsigns.preview_hunk_inline)
	end
}
