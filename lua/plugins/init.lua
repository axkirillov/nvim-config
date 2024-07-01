return {
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",

	{
		'nvim-tree/nvim-tree.lua',
		dependencies = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
	},

	{ 'dag/vim-fish' },

	'tpope/vim-fugitive',

	-- completion
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',

	'saadparwaiz1/cmp_luasnip',

	'samoshkin/vim-mergetool',

	-- Diffview
	{ 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },

	-- Justfile syntax highlighting
	'NoahTheDuke/vim-just',

	"folke/neodev.nvim",

	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			vim.diagnostic.config({
				virtual_text = false,
			})

			require("lsp_lines").setup()
		end,
	},

	'towolf/vim-helm',

	'github/copilot.vim',

	{
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
				-- add any options here
			})
		end,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		}
	},

	-- open git files in browser
	'tpope/vim-rhubarb',
}
