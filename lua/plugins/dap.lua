local dap = require('dap')

dap.adapters.php = {
	type = 'executable',
	command = 'php-debug-adapter',
}

dap.configurations.php = {
	{
		type = 'php',
		request = 'launch',
		name = 'Listen for Xdebug',
		port = 9003,
		pathMappings = {
			["/myposter"] = "${workspaceFolder}"
		}
	}
}

dap.adapters.delve = {
	type = 'server',
	port = '${port}',
	executable = {
		command = 'dlv',
		args = { 'dap', '-l', '127.0.0.1:${port}' },
	}
}

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
	{
		type = "delve",
		name = "Debug",
		request = "launch",
		program = "${workspaceFolder}/cmd/server/main.go",
		env = {
			CGO_CFLAGS_ALLOW = "-Xpreprocessor",
			CACHE = "filesystem",
			ENVIRONMENT = "development",
			LOG_LEVEL = "info",
			PORT = "8001"
		}
	},
}

vim.api.nvim_create_user_command('Continue', ":lua require('dap').continue()", {})
vim.api.nvim_create_user_command('Breakpoint', ":lua require('dap').toggle_breakpoint()", {})
