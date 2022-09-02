require("telescope").load_extension('command_center')

local command_center = require("command_center")

command_center.add({
	{
		description = "Show changed files",
		cmd = "<CMD>Easypick changed_files<CR>",
	},
	{
		description = "Edit init.vim",
		cmd = "<CMD>e $CONFIG/nvim/init.vim<CR>",
	},
	{
		description = "Source init.vim and reload configs",
		cmd = "<CMD>source $CONFIG/nvim/init.vim<CR>",
	},
	{
		description = "Find in configs",
		cmd = "<CMD>Easypick config_files<CR>",
	},
	{
		description = "Delete all buffers",
		cmd = "<CMD>%bd|e#<CR>",
	},
	{
		description = "Pick git branch",
		cmd = "<CMD>Telescope git_branches<CR>",
	},
	{
		description = "List files with conflicts",
		cmd = "<CMD>Easypick conflicts<CR>",
	},
})
