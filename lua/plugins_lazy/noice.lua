return {
	"folke/noice.nvim",
	config = function()
		require("noice").setup({
			-- add any options here

		})

		-- add a mapping to call Noice dismiss
		vim.api.nvim_set_keymap("n", "<C-l>", "<cmd>Noice dismiss<cr>", { noremap = true, silent = true })
	end,
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	}
}
