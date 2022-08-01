local plugindir = vim.fn.expand('$NVCFG')

local M = {}

function M.pick()
	local opts = {
		prompt_title = "~ config files 🚎 ~",
		previewer = false,
		find_command = {
			"fd",
			"-i",
			"-t=f",
			"--search-path=" .. plugindir,
		},
	}
	return require('telescope.builtin').find_files(opts)
end

return M
