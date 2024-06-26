vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rg", ":FzfLua grep_project<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>", { noremap = true, silent = true })

return {
	'ibhagwan/fzf-lua',
	opts = { 'telescope' }
}
