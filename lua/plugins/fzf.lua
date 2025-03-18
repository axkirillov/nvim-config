local keymap_opts = {
  noremap = true,
  silent = true,
}

vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>", keymap_opts)
vim.keymap.set("n", "<leader>rg", ":FzfLua grep_project<CR>", keymap_opts)
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>", keymap_opts)
vim.keymap.set("n", "<leader>g", ":FzfLua git_status<CR>", keymap_opts)

local default_branch

local get_default_branch = function()
	if not default_branch then
		local command = "git remote show origin | grep 'HEAD branch' | cut -d' ' -f5"
		default_branch = vim.fn.system(command) or "main"
	end
	return default_branch
end

-- Custom function to get files changed by a commit
local function get_files_changed(commit_hash)
	local command = string.format("git show --pretty='' --name-only %s", commit_hash)
	return vim.fn.systemlist(command)
end

return {
	'ibhagwan/fzf-lua',
	cmd = "FzfLua",
	config = function()
		local fzf_lua = require("fzf-lua")

		-- Configure FzfLua for git commits
		fzf_lua.setup({
			'telescope',
			git = {
				commits = {
					cmd = "git log --oneline --color",
					preview = "git show --pretty='%C(yellow)%h%Creset %s %C(cyan)(%cr)%Creset' --color {1}",
					actions = {
						["default"] = function(selected)
							local commit_hash = selected[1]:match("%S+")
							local files = get_files_changed(commit_hash)
							fzf_lua.fzf_exec(files, {
								prompt = "Files changed in " .. commit_hash .. ": ",
								actions = {
									["default"] = fzf_lua.actions.file_edit
								}
							})
						end,
					},
				},
			},
			lsp = {
				code_actions = {
					previewer = "codeaction_native",
					preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS",
				},
			},
			grep = {
			}
		})

		vim.api.nvim_create_user_command(
			"BranchDiff",
			function()
				fzf_lua.files({ cmd = "git diff --name-only $(git merge-base HEAD " .. get_default_branch() .. " )" })
			end,
			{}
		)
		vim.api.nvim_create_user_command(
			"Conflicts",
			function()
				fzf_lua.files({ cmd = "git diff --name-only --diff-filter=U --relative" })
			end,
			{}
		)
		vim.api.nvim_create_user_command("Commits", fzf_lua.git_commits, {})
	end

}
