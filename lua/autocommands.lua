local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Search Highlighting Group
local search_highlight_group = augroup("SearchHighlighting", { clear = true })
autocmd("CmdlineEnter", {
  pattern = { "/", "?" },
  group = search_highlight_group,
  callback = function()
    vim.o.hlsearch = true
  end
})
autocmd("CmdlineLeave", {
  pattern = { "/", "?" },
  group = search_highlight_group,
  callback = function()
    vim.o.hlsearch = false
  end
})

-- General Settings Group
local general_group = augroup("GeneralSettings", { clear = true })
autocmd("BufModifiedSet", {
  group = general_group,
  callback = function()
    vim.cmd("silent! w")
  end,
  desc = "Auto Save"
})
