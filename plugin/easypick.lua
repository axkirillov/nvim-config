local easypick = require("easypick")

local base_branch = vim.g.base_branch or "develop"


local list = [[
<< EOF
:Easypick changed_files
:Easypick conflicts
:Easypick config_files
EOF
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
			name = "command_palette",
			command = "cat " .. list,
			action = easypick.actions.run_nvim_command,
			opts = require('telescope.themes').get_dropdown({})
		}
	}
})
