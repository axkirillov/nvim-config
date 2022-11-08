local easypick = require("easypick")

local base_branch = vim.g.base_branch or "develop"


local list = [[
<< EOF
:Easypick changed_files
:Easypick conflicts
:Easypick config_files
:Easypick make_targets
EOF
]]

local list_make_targets = [[
make -qp |
awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' |
grep -wv Makefile
]]

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function run_make_target(prompt_bufnr, _)
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    vim.cmd("FloatermNew make " .. selection[1])
  end)
  return true
end

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
		},
		{
			name = "make_targets",
			command = list_make_targets,
			action = run_make_target,
			opts = require('telescope.themes').get_dropdown({})
		}
	}
})

local ns = { noremap = true, silent = true }
vim.keymap.set("n", "<C-p>", ":Easypick command_palette<CR>", ns)
vim.keymap.set("n", "<leader>m", ":Easypick make_targets<CR>", ns)
