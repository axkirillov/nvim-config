local setup = function()
	local actions = require("telescope.actions")
	require "telescope".setup {
		defaults = {
			mappings = {
				n = {
				},
				i = {
					["<esc>"] = actions.close,
					["<C-j>"] = actions.select_default,
				}

			},
			preview = {
				treesitter = false
			},
			layout_config = {
				height = 0.95,
				width = 0.99
			},
			wrap_results = true
		},

		pickers = {
			find_files = {
				find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "-E", ".git", "-H" },
			},
			git_branches = {
				theme = "dropdown",
				previewer = false
			}
		},
	}

	require('telescope').load_extension('fzf')
	require('telescope').load_extension('hbac')

	local ns = { noremap = true, silent = true }
	local symbols = function()
		require 'telescope.builtin'.lsp_document_symbols(require('telescope.themes').get_dropdown({ previewer = false }))
	end
	vim.keymap.set("n", "<leader>s", symbols, ns)
end

return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		{ 'nvim-lua/plenary.nvim' },
	},
	config = setup,
}
