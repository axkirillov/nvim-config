vim.keymap.set('n', ']h', function() require('unified.navigation').next_hunk() end)
vim.keymap.set('n', '[h', function() require('unified.navigation').previous_hunk() end)

vim.keymap.set('n', '<leader>u', '<cmd>DiffMergeBase<cr>', { silent = true, desc = 'Unified diff vs merge-base' })

local function trim(s)
	if type(s) ~= "string" then
		return ""
	end
	return (vim.trim and vim.trim(s)) or vim.fn.trim(s)
end

local function system_trim(cmd)
	local ok, proc = pcall(vim.system, cmd, { text = true })
	if not ok or not proc then
		return nil
	end
	local res = proc:wait()
	if res.code ~= 0 then
		return nil
	end
	return trim(res.stdout or "")
end

local function in_git_repo()
	local inside = system_trim({ "git", "rev-parse", "--is-inside-work-tree" })
	return inside == "true"
end

local function default_base_ref()
	local head = system_trim({ "git", "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD" })
	if head and head ~= "" then
		return head
	end
	return "origin/main"
end

-- Add custom command to show diff between merge-base and HEAD
vim.api.nvim_create_user_command(
	'DiffMergeBase',
	function()
		if not in_git_repo() then
			vim.notify("Not inside a git work tree", vim.log.levels.WARN)
			return
		end
		local base_ref = default_base_ref()
		local merge_base = system_trim({ "git", "merge-base", "HEAD", base_ref })
		if not merge_base or merge_base == "" then
			vim.notify("Failed to compute merge-base vs " .. base_ref, vim.log.levels.ERROR)
			return
		end
		-- Open diffview between merge-base and HEAD
		vim.cmd('Unified ' .. merge_base)
	end,
	{ desc = 'Open diff between merge-base and HEAD' }
)

return {
	dir = '~/repo/unified.nvim',
	opts = {},
}
