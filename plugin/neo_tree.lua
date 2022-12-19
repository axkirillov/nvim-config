vim.keymap.set('n', '<C-n>', '<Cmd>Neotree toggle reveal<CR>')
vim.keymap.set('n', '<leader>nb', '<Cmd>Neotree toggle reveal buffers<CR>')
vim.keymap.set('n', '<leader>s', '<Cmd>Neotree toggle reveal git_status<CR>')

require("neo-tree").setup({
	close_if_last_window = true,
	-- This will find and focus the file in the active buffer every
	-- time the current file is changed while the tree is open.
	follow_current_file = true,
	filesystem = {
		filtered_items = {
			visible = true, -- when true, they will just be displayed differently than normal items
			hide_dotfiles = true,
			hide_gitignored = true,
			hide_hidden = true, -- only works on Windows for hidden files/directories
			hide_by_name = {
				--"node_modules"
			},
			hide_by_pattern = { -- uses glob style patterns
				--"*.meta"
			},
			never_show = { -- remains hidden even if visible is toggled to true
				--".DS_Store",
				--"thumbs.db"
			},
		}
	},
	window = {
		position = "left",
		width = 30,
		mapping_options = {
			noremap = true,
			nowait = true,
		},
		mappings = {
		}
	},
}
)
