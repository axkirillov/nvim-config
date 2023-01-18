return function(use)
	-- packer itself
	use 'wbthomason/packer.nvim'

	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	-- install and configure language servers
	use { "neovim/nvim-lspconfig" }
	use { "williamboman/mason.nvim" }
	use { "williamboman/mason-lspconfig.nvim" }

	-- debug
	use 'mfussenegger/nvim-dap'
	use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

	-- nice looking menus
	use {'stevearc/dressing.nvim'}

	use { 'ibhagwan/fzf-lua' }

	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
	}

	-- better quickfix
	use {'kevinhwang91/nvim-bqf'}

	use {'dag/vim-fish'}

	use 'voldikss/vim-floaterm'

	use 'puremourning/vimspector'

	use {"junegunn/fzf.vim", requires = {"junegunn/fzf"}, run = function() vim.fn["fzf#install"]() end}

	use {'axkirillov/easypick.nvim', branch = 'test', requires = 'nvim-telescope/telescope.nvim'}

	use 'tpope/vim-fugitive'

	-- completion
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'

	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'

	use 'samoshkin/vim-mergetool'

	use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons", }

	-- status ui for lsp
	use 'j-hui/fidget.nvim'

	-- for plugin development
	use "folke/lua-dev.nvim"

	use { "catppuccin/nvim", as = "catppuccin" }

	-- close buffers gracefully
	use "moll/vim-bbye"

	-- useful treesitter actions (multiline / join lists, swap case)
	use({
		'ckolkey/ts-node-action',
		requires = { 'nvim-treesitter' },
	})

	-- Unless you are still migrating, remove the deprecated commands from v1.x
	vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

	use {
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		}
	}
	-- ChatGPT
	use({
		"jackMort/ChatGPT.nvim",
		config = function()
			require("chatgpt").setup({
				-- optional configuration
			})
		end,
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		}
	})

	-- Diffview
	use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

	use 'ggandor/leap.nvim'

	-- Justfile syntax highlighting
	use 'NoahTheDuke/vim-just'

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end
