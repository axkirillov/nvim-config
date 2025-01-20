-- Search Highlighting Group
local search_highlight_group = vim.api.nvim_create_augroup("SearchHighlighting", { clear = true })
vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = { "/", "?" },
  group = search_highlight_group,
  callback = function()
    vim.o.hlsearch = true
  end
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = { "/", "?" },
  group = search_highlight_group,
  callback = function()
    vim.o.hlsearch = false
  end
})

-- General Settings Group
local general_group = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })
vim.api.nvim_create_autocmd("BufModifiedSet", {
  group = general_group,
  callback = function()
    vim.cmd("silent! w")
  end,
  desc = "Auto Save"
})

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd('normal! g`"zz')
        end
    end,
})
