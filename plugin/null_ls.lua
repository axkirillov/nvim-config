local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.phpstan.with {
			command = "vendor/bin/phpstan",
			method = null_ls.methods.DIAGNOSTICS_ON_SAVE
		}
	},
})
