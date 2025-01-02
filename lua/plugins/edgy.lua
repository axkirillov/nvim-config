local function find_longest_line()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local max_length = 0

	for _, line in ipairs(lines) do
		max_length = math.max(max_length, vim.fn.strdisplaywidth(line))
	end

	return max_length
end

local function toggle_auto_expand_width(win)
	local win_width = vim.api.nvim_win_get_width(0)
	local state = require("neo-tree.sources.manager").get_state("filesystem")
	if state.window.auto_expand_width then
		win.view.edgebar:equalize()
	end
	require("neo-tree.sources.common.commands").toggle_auto_expand_width(state)
	local longest_line = find_longest_line()
	while win_width < longest_line + 1 do
		win:resize("width", 1)
		win_width = win_width + 1
	end
end

local opts = {
	-- enable this to exit Neovim when only edgy windows are left
	exit_when_last = true,
	-- buffer-local keymaps to be added to edgebar buffers.
	-- Existing buffer-local keymaps will never be overridden.
	-- Set to false to disable a builtin.
	---@type table<string, fun(win:Edgy.Window)|false>
	keys = {
		["e"] = toggle_auto_expand_width,
	},
	left = {
		-- Neo-tree filesystem always takes half the screen height
		{
			title = "Neo-Tree",
			ft = "neo-tree",
			filter = function(buf)
				return vim.b[buf].neo_tree_source == "filesystem"
			end,
			size = { height = 0.5 },
		},
		{
			title = "Outline",
			ft = "Outline",
		},
	},
	bottom = {
		"Trouble",
		{ ft = "qf",            title = "QuickFix" },
		{
			ft = "help",
			size = { height = 20 },
			-- only show help buffers
			filter = function(buf)
				return vim.bo[buf].buftype == "help"
			end,
		},
		{ ft = "spectre_panel", size = { height = 0.4 } },
	},
}
return {
	"folke/edgy.nvim",
	event = "VeryLazy",
	init = function()
		vim.opt.laststatus = 3
		vim.opt.splitkeep = "screen"
	end,
	opts = opts,
}
