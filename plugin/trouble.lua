require("trouble").setup {
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
}

vim.keymap.set('n', '<C-T>', '<cmd> :TroubleToggle <CR>', {silent = true, noremap = true})

