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
	require "telescope".load_extension("agrolens")
	require('telescope').load_extension('hbac')

	local ns = { noremap = true, silent = true }
	vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>", ns)
	vim.keymap.set("n", "<leader>b", ":Telescope hbac buffers<CR>", ns)
	vim.keymap.set("n", "<leader>t", ":Telescope<CR>", ns)
	vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>", ns)
	vim.keymap.set("n", "<leader>g", ":Telescope git_status<CR>", ns)
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
