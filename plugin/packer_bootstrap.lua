local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
---@diagnostic disable-next-line: lowercase-global
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
	-- packer itself
	use 'wbthomason/packer.nvim'

	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

	use {'nvim-lua/plenary.nvim'}

	use {'nvim-telescope/telescope.nvim'}

	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	-- install and configure language servers
	use { "neovim/nvim-lspconfig" }
	use { "williamboman/mason.nvim" }
	use { "williamboman/mason-lspconfig.nvim" }

	-- nice command pallete
	use { "gfeiyou/command-center.nvim", requires = { "nvim-telescope/telescope.nvim" } }

	-- github integration
	use {'pwntester/octo.nvim'}

	-- best status line
	use {'nvim-lualine/lualine.nvim'}

	-- debug
	use 'mfussenegger/nvim-dap'
	use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

	-- nice looking menus
	use {'stevearc/dressing.nvim'}

	use { 'ldelossa/gh.nvim', requires = { { 'ldelossa/litee.nvim' } } }

	use { 'ibhagwan/fzf-lua' }

	-- Unless you are still migrating, remove the deprecated commands from v1.x
	vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

	use {
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		}
	}

	-- better quickfix
	use {'kevinhwang91/nvim-bqf'}

	use {'dag/vim-fish'}

	use 'voldikss/vim-floaterm'

	use 'AndrewRadev/splitjoin.vim'

	use 'morhetz/gruvbox'

	use 'puremourning/vimspector'

	-- vnoremap <unique> <Leader>== :call PhpAlignAssigns()<CR>
	-- ^^^ the only reason I have this
	use 'adoy/vim-php-refactoring-toolbox'

	use {
		'phpactor/phpactor',
		branch = 'master',
		ft = 'php',
		run = 'composer install --no-dev -o',
	}

	use {"junegunn/fzf.vim", requires = {"junegunn/fzf"}, run = function() vim.fn["fzf#install"]() end}

	use 'lewis6991/gitsigns.nvim'

	use {'axkirillov/easypick.nvim', requires = 'nvim-telescope/telescope.nvim'}

	use 'tpope/vim-fugitive'

	-- completion
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'

	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'

	use "kylechui/nvim-surround"

	use 'jose-elias-alvarez/null-ls.nvim'

	use 'samoshkin/vim-mergetool'

	use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

	use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons", }

	-- swapping function variables and other text objects
	use 'mizlan/iswap.nvim'

	-- status ui for lsp
	use 'j-hui/fidget.nvim'

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end)
