local setup = function()
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
				["/myposter"] = "${workspaceFolder}",
				["/shop-backend"] = "${workspaceFolder}"
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

	local keymap_opts = {
    noremap = true,
    silent = true,
  }

	vim.keymap.set("n", "<F5>", function() dap.continue() end, keymap_opts)
	vim.keymap.set("n", "<F9>", function() dap.toggle_breakpoint() end, keymap_opts)
	vim.keymap.set("n", "<F10>", function() dap.step_over() end, keymap_opts)
	vim.keymap.set("n", "<F11>", function() dap.step_into() end, keymap_opts)
	vim.keymap.set("n", "<F12>", function() dap.step_out() end, keymap_opts)
end

return {
	'mfussenegger/nvim-dap',
	config = setup,
}
