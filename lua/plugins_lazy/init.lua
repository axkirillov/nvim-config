return {
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	'mfussenegger/nvim-dap',
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },

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

	'voldikss/vim-floaterm',

	'puremourning/vimspector',

	{ "junegunn/fzf.vim", dependencies = { "junegunn/fzf" }, build = function() vim.fn["fzf#install"]() end },

	{ 'axkirillov/easypick.nvim', branch = 'test', dependencies = 'nvim-telescope/telescope.nvim' },

	'tpope/vim-fugitive',

	-- completion
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/nvim-cmp',

	'L3MON4D3/LuaSnip',
	"rafamadriz/friendly-snippets",
	'saadparwaiz1/cmp_luasnip',

	'samoshkin/vim-mergetool',

	{ "folke/trouble.nvim", dependencies = "nvim-tree/nvim-web-devicons", },

	-- status ui for lsp
	'j-hui/fidget.nvim',

	-- for plugin development
	"folke/lua-dev.nvim",

	{ "catppuccin/nvim", as = "catppuccin" },

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
	-- ChatGPT
	{
		"jackMort/ChatGPT.nvim",
		config = function()
			require("chatgpt").setup({
				-- optional configuration
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		}
	},

	-- Diffview
	{ 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },

	'ggandor/leap.nvim',

	-- Justfile syntax highlighting
	'NoahTheDuke/vim-just',

	{
		'Wansmer/treesj',
		dependencies = { 'nvim-treesitter' },
		config = function()
			require('treesj').setup({ --[[ your config ]] })
		end,
	},

	"folke/neodev.nvim",

	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
		end,
	},

	'echasnovski/mini.bracketed',
	{
		"aaronhallaert/ts-advanced-git-search.nvim",
		config = function()
			require("telescope").load_extension("advanced_git_search")
		end,
		dependencies = {
			"nvim-telescope/telescope.nvim",
			-- to show diff splits and open commits in browser
			"tpope/vim-fugitive",
		},
	},
}
