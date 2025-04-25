return {
	"axkirillov/easypick.nvim",
	branch = "develop",
	dependencies = {
		'ibhagwan/fzf-lua',
		--"nvim-telescope/telescope.nvim",
	},
	cmd = "Easypick",
	config = function()
		local easypick = require("easypick")

		-- only required for the example to work
		local base_branch = function()
			return vim.fn.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5")
					or "main"
		end
		local list = [[
			<< EOF
				:FzfLua files
				:Git blame
			EOF
		]]
		easypick.setup({
			pickers = {
				{
					name = "ls",
					command = "ls",
					previewer = easypick.previewers.default()
				},
				{
					name = "command_palette",
					command = "cat " .. list,
					-- pass a pre-configured action that runs the command
					action = easypick.actions.nvim_commandf("%s"),
					-- you can specify any theme you want, but the dropdown looks good for this example =)
					opts = require('telescope.themes').get_dropdown({})
				}
			}
		})
	end
}
