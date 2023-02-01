"turn search highlight off on command mode leave
augroup ToggleSearchHighlighting
au!
autocmd CmdlineEnter \?,/ set hlsearch
autocmd CmdlineLeave \?,/ set nohlsearch
augroup END

lua << EOF

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local general = augroup("General Settings", { clear = true })

autocmd("BufModifiedSet", {
  callback = function()
    vim.cmd "silent! w"
  end,
  group = general,
  desc = "Auto Save",
})

EOF
