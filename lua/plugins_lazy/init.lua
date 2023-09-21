return {
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",

	'mfussenegger/nvim-dap',

	{ "rcarriga/nvim-dap-ui",  dependencies = { "mfussenegger/nvim-dap" } },

	-- nice looking menus
	{ 'stevearc/dressing.nvim' },

	{ 'ibhagwan/fzf-lua' },

	{
		'nvim-tree/nvim-tree.lua',
		dependencies = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
	},

	-- better quickfix
	{ 'kevinhwang91/nvim-bqf' },

	{ 'dag/vim-fish' },
	{ "junegunn/fzf.vim",         dependencies = { "junegunn/fzf" }, build = function() vim.fn["fzf#install"]() end },
	'tpope/vim-fugitive',

	-- completion
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/nvim-cmp',

	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip/loaders/from_vscode").load()
		end,
	},

	'saadparwaiz1/cmp_luasnip',

	'samoshkin/vim-mergetool',

	-- close buffers gracefully
	"moll/vim-bbye",

	-- useful treesitter actions (multiline / join lists, swap case)
	{
		'ckolkey/ts-node-action',
		dependencies = { 'nvim-treesitter' },
	},

	-- Unless you are still migrating, remove the deprecated commands from v1.x
	--vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		}
	},

	-- Diffview
	{ 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },

	-- Justfile syntax highlighting
	'NoahTheDuke/vim-just',

	"folke/neodev.nvim",

	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
		end,
	},

	'echasnovski/mini.bracketed',

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

	{
		'al-ce/hbac.nvim',
		config = function()
			require("hbac").setup()
		end,
		branch = "default_opts"
	},

	-- open git files in browser
	'tpope/vim-rhubarb',
}
