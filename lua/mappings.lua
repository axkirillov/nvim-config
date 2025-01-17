-- delete to black hole register if line is empty
vim.keymap.set("n", "dd", function ()
	if vim.fn.getline(".") == "" then return '"_dd' end
	return "dd"
end, {expr = true})
-- Set leader key
vim.g.mapleader = ' '

-- Exit terminal mode
vim.keymap.set('t', '<C-e>', '<C-\\><C-n>')

-- Paste unix timestamp
vim.keymap.set('n', '<F2>', function()
  local timestamp = vim.fn.substitute(vim.fn.system('gdate +%s%3N'), '\\n\\+$', '', '')
  vim.fn.setreg('=', timestamp)
  vim.cmd('normal p')
end)

-- Open diagnostic in a float window
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float)

-- Close quickfix
vim.keymap.set('', '<C-c>', ':ccl<cr>')

-- More comfortable movement
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')
vim.keymap.set('', 'J', '}')
vim.keymap.set('', 'K', '{')

-- Give a new home to J
vim.keymap.set('', 'M', 'J')

-- Lazygit
vim.keymap.set('', '<C-g>', ':!tmux split-window -Z -c "#{pane_current_path}" "lazygit"<cr>')

-- Popup terminal
vim.keymap.set('', '<F1>', ':!tmux popup -E -w 160 -h 40 -d $(pwd)<cr>')

-- Git blame (requires fugitive)
vim.keymap.set('n', 'gb', ':Gblame<CR>')

-- disable c-w h
vim.keymap.set('n', '<C-w>h', '<Nop>')
