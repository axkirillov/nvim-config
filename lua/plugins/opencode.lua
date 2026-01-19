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
		if opts.provider == nil then
			opts.provider = {}
		end
		if type(opts.provider) == "table" and not (opts.provider.toggle or opts.provider.start or opts.provider.stop) then
			opts.provider.snacks = opts.provider.snacks or {}
			opts.provider.snacks.win = opts.provider.snacks.win or {}
			opts.provider.snacks.win.enter = true
		end
		vim.g.opencode_opts = opts
		vim.o.autoread = true

		vim.keymap.set({ "n", "t" }, "<F2>", function()
			require("opencode").toggle()
		end)
	end,
}
