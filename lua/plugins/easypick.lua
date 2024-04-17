-- get default branch
local default_branch = vim.fn.system("git rev-parse --symbolic-full-name refs/remotes/origin/HEAD | sed 's!.*/!!'") or
"main"

return {
	'axkirillov/easypick.nvim',
	branch = 'develop',
	dependencies = 'nvim-telescope/telescope.nvim',
	config = function()
		local easypick = require("easypick")
		easypick.setup({
			pickers = {
				{
					name = "changed files",
					command = "git diff --name-only $(git merge-base HEAD " .. default_branch .. " )",
					previewer = easypick.previewers.branch_diff({ base_branch = default_branch })
				},
				{
					name = "conflicts",
					command = "git diff --name-only --diff-filter=U --relative",
					previewer = easypick.previewers.file_diff(),
				},
			}
		})

		local ns = { noremap = true, silent = true }
		vim.keymap.set("n", "<C-p>", ":Easypick<CR>", ns)
	end
}
