local easypick = require("easypick")

local base_branch = vim.g.base_branch or "develop"

local list_make_targets = [[
make -qp |
awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' |
grep -wv Makefile
]]

easypick.setup({
	pickers = {
		{
			name = "changed_files",
			command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
			previewer = easypick.previewers.branch_diff({base_branch = base_branch})
		},
		{
			name = "conflicts",
			command = "git diff --name-only --diff-filter=U --relative",
			previewer = easypick.previewers.file_diff(),
		},
		{
			name = "config_files",
			command = "fd -i -t=f --search-path=" ..  vim.fn.expand('$NVIM_CONFIG'),
			previewer = easypick.previewers.default()
		},
		{
			name = "make_targets",
			command = list_make_targets,
			action = easypick.actions.nvim_command("FloatermNew make"),
			opts = require('telescope.themes').get_dropdown({})
		}
	}
})

local ns = { noremap = true, silent = true }
vim.keymap.set("n", "<C-p>", ":Easypick<CR>", ns)
vim.keymap.set("n", "<leader>m", ":Easypick make_targets<CR>", ns)
