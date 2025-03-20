-- Load settings, mappings, commands and autocommands
require("settings")
require("mappings")
require("commands")
require("autocommands")
require("claude")
require("lazy_bootstrap")
require("lazy").setup(
	"plugins",
	{
		change_detection = {
			enabled = true,
			notify = false,
		},
	}
)

-- Set colorscheme
vim.cmd('colorscheme catppuccin-macchiato')
