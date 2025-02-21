return {
	"axkirillov/easypick.nvim",
	branch = "develop",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local easypick = require("easypick")

		-- only required for the example to work
		local get_default_branch = "git remote show origin | grep 'HEAD branch' | cut -d' ' -f5"
		local base_branch = vim.fn.system(get_default_branch) or "main"

		easypick.setup({
			pickers = {
				{
          name = "git_commits",
          command = "git log --oneline --reverse",
          previewer = easypick.previewers.default()
        },
				{
					name = "changed_files",
					command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
					--	previewer = easypick.previewers.branch_diff({ base_branch = base_branch })
				},

				-- list files that have conflicts with diffs in preview
				{
					name = "conflicts",
					command = "git diff --name-only --diff-filter=U --relative",
					-- previewer = easypick.previewers.file_diff()
				},
			}
		})
	end
}
