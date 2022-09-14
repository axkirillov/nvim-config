local actions = require("telescope.actions")
require "telescope".setup {
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<esc>"] = actions.close,
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
			find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "-E", ".git", "-H"},
		},
		git_branches = {
			theme = "dropdown",
			previewer = false
		}
	},
}

require('telescope').load_extension('fzf')
require'telescope'.load_extension('make')

local ns = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>", ns)
vim.keymap.set("n", "<leader>b", ":Telescope buffers<CR>", ns)
vim.keymap.set("n", "<leader>t", ":Telescope<CR>", ns)
vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>", ns)
vim.keymap.set("n", "<leader>m", ":Telescope make<CR>", ns)
