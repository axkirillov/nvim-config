return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		local supermaven = require("supermaven-nvim")
		supermaven.setup({
			keymaps = {
				accept_suggestion = "<Tab>",
				accept_word = "<M-]>",
			},
		})
	end,
}
