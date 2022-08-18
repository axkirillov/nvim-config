local dap = require('dap')

dap.adapters.php = {
	type = 'executable',
	command = 'node',
}

dap.configurations.php = {
	{
		type = 'php',
		request = 'launch',
		name = 'Listen for Xdebug',
		port = 9000
	}
}

dap.adapters.delve = {
	type = 'server',
	port = '${port}',
	executable = {
		command = 'dlv',
		args = {'dap', '-l', '127.0.0.1:${port}'},
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
