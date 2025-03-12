return
{
	"mistweaverco/kulala.nvim",
	config = function()
		local kulala = require("kulala")
		kulala.setup()
		vim.api.nvim_create_user_command(
			"Kulala",
			function()
				kulala.run()
			end,
			{}
		)
	end
}
