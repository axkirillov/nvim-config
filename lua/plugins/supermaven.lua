return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		local supermaven = require("supermaven-nvim")
		local completion_preview = require("supermaven-nvim.completion_preview")
		supermaven.setup({
			disable_keymaps = true,
		})
		vim.keymap.set(
			'i',
			'<m-f>',
			function()
				if completion_preview.has_suggestion() then
					completion_preview.on_accept_suggestion_word()
					return
				end

				require("readline").forward_word()
			end,
			{ silent = true }
		)
		vim.keymap.set(
			'i',
			'<Tab>',
			completion_preview.on_accept_suggestion,
			{ silent = true }
		)
	end,
}
