vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rg", ":FzfLua grep_project<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>g", ":FzfLua git_status<CR>", { noremap = true, silent = true })

local default_branch
local branch_diff = function()
	if not default_branch then
		local command = "git remote show origin | grep 'HEAD branch' | cut -d' ' -f5"
		default_branch = vim.fn.system(command) or "main"
	end
	local command = "git diff --name-only $(git merge-base HEAD " .. default_branch .. " )"
	require 'fzf-lua'.files({ cmd = command })
end

local conflicts = function()
	local command = "git diff --name-only --diff-filter=U --relative"
	require 'fzf-lua'.files({ cmd = command })
end

local function_table = {
	["branch_diff"] = branch_diff,
	["conflicts"] = conflicts,
}

local function run_lua_function_picker()
	local fzf = require('fzf-lua')
	local function_names = {}
	for name, _ in pairs(function_table) do
		table.insert(function_names, name)
	end

	fzf.fzf_exec(function_names, {
		prompt = "Select a Lua function to run: ",
		actions = {
			["default"] = function(selected)
				local func = function_table[selected[1]]
				if func then
					func()
				else
					print("Function not found")
				end
			end
		}
	})
end

vim.keymap.set("n", "<c-p>", run_lua_function_picker, { noremap = true, silent = true })

return {
	'ibhagwan/fzf-lua',
	opts = { 'telescope' },
}
