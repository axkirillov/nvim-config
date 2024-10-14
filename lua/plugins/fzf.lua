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
	config = function()
		local fzf = require("fzf-lua")

		-- Custom function to get files changed by a commit
		local function get_files_changed(commit_hash)
			local command = string.format("git show --pretty='' --name-only %s", commit_hash)
			return vim.fn.systemlist(command)
		end

		-- Custom action to show files changed by a commit
		local function show_files_changed(selected)
			local commit_hash = selected[1]:match("%S+")
			local files = get_files_changed(commit_hash)
			fzf.fzf_exec(files, {
				prompt = "Files changed in " .. commit_hash .. ": ",
				actions = {
					["default"] = fzf.actions.file_edit
				}
			})
		end

		-- Configure FzfLua for git commits
		fzf.setup({
			'telescope',
			git = {
				commits = {
					cmd = "git log --oneline --color",
					preview = "git show --pretty='%C(yellow)%h%Creset %s %C(cyan)(%cr)%Creset' --color {1}",
					actions = {
						["default"] = show_files_changed,
					},
				},
			},
		})

		-- Register Ex command to open git commits
		vim.api.nvim_create_user_command('FzfGitCommits', function()
			require('fzf-lua').git_commits()
		end, {})
	end

}
