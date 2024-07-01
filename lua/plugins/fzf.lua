vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rg", ":FzfLua grep_project<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>g", ":FzfLua git_status<CR>", { noremap = true, silent = true })


local branch_diff = function()
	local default_branch = vim.fn.system("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5") or
	"main"
	local command = "git diff --name-only $(git merge-base HEAD " .. default_branch .. " )"
	require 'fzf-lua'.files({ cmd = command })
end

local conflicts = function()
	local command = "git diff --name-only --diff-filter=U --relative"
	require 'fzf-lua'.files({ cmd = command })
end

vim.keymap.set("n", "<leader>pf", branch_diff, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>pc", conflicts, { noremap = true, silent = true })

return {
	'ibhagwan/fzf-lua',
	opts = { 'telescope' },
}
