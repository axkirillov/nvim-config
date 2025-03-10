local function accept_copilot_word()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(copilot-accept-word)", true, true, true), "i", true)
end

return {
	"github/copilot.vim",
	config = function()
		vim.keymap.set(
			'i',
			'<m-f>',
			function()
				local suggestion = vim.fn["copilot#GetDisplayedSuggestion"]()
				if suggestion and suggestion.text ~= "" then
					accept_copilot_word()
					return
				end

				require("readline").forward_word()
			end,
			{ silent = true }
		)
	end
}
