return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				anti_conceal = { enabled = false },
				file_types = { "markdown" },
			},
			ft = { "markdown", "Avante", "copilot-chat" },
		},
		"saghen/blink.cmp",
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	config = function()
		local opts = vim.g.opencode_opts
		if type(opts) ~= "table" then
			opts = {}
		end
		opts.events = opts.events or {}
		opts.events.permissions = { enabled = false }
		vim.g.opencode_opts = opts
		vim.o.autoread = true

		vim.keymap.set({ "n", "t" }, "<F2>", function()
			require("opencode").toggle()
		end)
	end,
}
