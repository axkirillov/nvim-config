return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim",        words = { "Snacks" } },
			},
		},
	},
	{ -- optional blink completion source for require statements and module annotations
		"saghen/blink.cmp",
		ft = "lua",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			opts.sources.providers = opts.sources.providers or {}
			opts.sources.providers.lazydev = opts.sources.providers.lazydev
				or {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				}

			-- Ensure lazydev is enabled as a source (keep existing ordering).
			opts.sources.default = opts.sources.default or {}
			local has = false
			for _, v in ipairs(opts.sources.default) do
				if v == "lazydev" then
					has = true
					break
				end
			end
			if not has then
				table.insert(opts.sources.default, 1, "lazydev")
			end
		end,
	}
}
