local keymap_opts = {
	noremap = true,
	silent = true,
}

local term_opts = {
	auto_close = false,
	win = { position = "float" },
}

---@param win snacks.win
local function close_other_terminals(win)
	local snacks = require("snacks")
	local terminals = snacks.terminal.list()
	for _, term in pairs(terminals) do
		if term.buf ~= win.buf then
			term:hide()
		end
	end
end
vim.keymap.set(
	"n",
	"<C-g>",
	function()
		local snacks = require("snacks")
		snacks.lazygit()
	end,
	keymap_opts
)

vim.keymap.set(
	"n",
	"<C-g>",
	function()
		local snacks = require("snacks")
		snacks.lazygit()
	end,
	keymap_opts
)

vim.keymap.set(
	{ "n", "t" },
	"<F1>",
	function()
		local snacks = require("snacks")
		local win = snacks.terminal.toggle("claude", term_opts)
		close_other_terminals(win)
		vim.cmd("checktime")
	end,
	keymap_opts
)

vim.keymap.set(
	{ "n", "t" },
	"<F2>",
	function()
		local snacks = require("snacks")
		local win = snacks.terminal.toggle(nil, term_opts)
		close_other_terminals(win)
		vim.cmd("checktime")
	end,
	keymap_opts
)



return
{
	"folke/snacks.nvim",
	opts = {
		lazygit = {
			config = {
				os = {
				}
			}
		},
		terminal = {
		},
		input = {
		},
		picker = {
		},
	},
}
