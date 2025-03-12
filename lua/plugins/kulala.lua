return
{
	"mistweaverco/kulala.nvim",
	config = function()
		local kulala = require("kulala")
		kulala.setup({
			ui = {
				display_mode = "float",
			}
		})
		vim.api.nvim_create_user_command(
			"Kulala",
			function(opts)
				if opts.args == "run" then
					kulala.run()
				elseif opts.args == "open" then
					kulala.open()
				else
					-- Default behavior when no arguments or unknown arguments
					kulala.open()
				end
			end,
			{ nargs = "?" }  -- Optional argument
		)
	end
}
