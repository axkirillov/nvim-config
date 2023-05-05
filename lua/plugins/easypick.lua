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
			name = "changed files",
			command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
			previewer = easypick.previewers.branch_diff({base_branch = base_branch})
		},
		{
			name = "conflicts",
			command = "git diff --name-only --diff-filter=U --relative",
			previewer = easypick.previewers.file_diff(),
		},
		{
			name = "make",
			command = list_make_targets,
			action = easypick.actions.nvim_command("FloatermNew --autoclose=0 make"),
			opts = require('telescope.themes').get_dropdown({})
		},
		{
			name = "just",
			command = "just --summary | tr ' ' '\n'",
			action = easypick.actions.nvim_command("FloatermNew --autoclose=0 just"),
			opts = require('telescope.themes').get_dropdown({})
		},
	}
})

local ns = { noremap = true, silent = true }
vim.keymap.set("n", "<C-p>", ":Easypick<CR>", ns)
