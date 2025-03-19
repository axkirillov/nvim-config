-- Turn syntax folding on (closes all folds automatically)
vim.api.nvim_create_user_command('Foldall', 'set fdm=syntax', {})

-- Format JSON using jq
vim.api.nvim_create_user_command('Jq', function()
	vim.cmd('%!jq')
	vim.o.syntax = 'json'
end, {})

-- Frequent typos
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('Qa', 'qa', {})

-- Open line in GitHub
vim.api.nvim_create_user_command('OpenLineInGithub', '.GBrowse', {})

-- Replace tabs with spaces
vim.api.nvim_create_user_command('ReTab', '%s/\\t/  /g', {})

-- Copy file path
vim.api.nvim_create_user_command('CopyFilePath', function()
	local relative_path = vim.fn.expand('%:.')
	vim.fn.setreg('*', relative_path)
end, {})

-- Paste unix timestamp
vim.api.nvim_create_user_command(
	'PasteTimestamp',
	function()
		local timestamp = vim.fn.substitute(vim.fn.system('gdate +%s%3N'), '\\n\\+$', '', '')
		vim.api.nvim_put({ timestamp }, 'c', true, true)
	end,
	{}
)

-- GitHub PR picker with fzf-lua
vim.api.nvim_create_user_command(
	'GitHubPRs',
	function()
		-- Get current repo from git remote
		local remote_url = vim.fn.trim(vim.fn.system("git remote get-url origin"))

		-- Extract owner and repo from URL
		local owner, repo
		if remote_url:match("github.com") then
			owner, repo = remote_url:match("github.com[:/]([^/]+)/([^/%.]+)")
		end

		if not owner or not repo then
			vim.notify("Could not determine GitHub repository from remote URL", vim.log.levels.ERROR)
			return
		end

		-- Remove .git suffix if present
		repo = repo:gsub("%.git$", "")

		-- Fetch PRs using GitHub CLI
		local cmd = string.format("gh pr list --json number,title,headRefName,url -L 100")
		local handle = io.popen(cmd)
		local result = handle:read("*a")
		handle:close()

		-- Parse JSON result
		local prs = vim.fn.json_decode(result)

		if #prs == 0 then
			vim.notify("No pull requests found", vim.log.levels.INFO)
			return
		end

		-- Format PRs for fzf-lua
		local formatted_prs = {}
		for _, pr in ipairs(prs) do
			table.insert(formatted_prs, string.format("#%d | %s | %s", pr.number, pr.headRefName, pr.title))
		end

		-- Open fzf-lua with the PRs
		local fzf_lua = require("fzf-lua")
		fzf_lua.fzf_exec(formatted_prs, {
			prompt = "GitHub PRs: ",
			actions = {
				-- Default action: checkout the PR
				["default"] = function(selected)
					local pr_number = selected[1]:match("#(%d+)")
					if pr_number then
						-- Checkout the PR
						vim.fn.system("gh pr checkout " .. pr_number)
						vim.notify("Checked out PR #" .. pr_number, vim.log.levels.INFO)
					end
				end,
				-- Custom action for opening PR in DiffView
				["ctrl-d"] = function(selected)
					local pr_number = selected[1]:match("#(%d+)")
					if pr_number then
						-- Get PR branch name
						local branch_name = selected[1]:match("#%d+ | ([^|]+) |")
						if branch_name then
							branch_name = vim.fn.trim(branch_name)
							-- Get default branch name
							local default_branch = vim.fn.trim(vim.fn.system(
							"git remote show origin | grep 'HEAD branch' | cut -d' ' -f5"))
							-- Open DiffView
							vim.cmd('DiffviewOpen ' .. default_branch .. '..' .. branch_name)
							vim.notify("Opened PR #" .. pr_number .. " in DiffView", vim.log.levels.INFO)
						end
					end
				end,
				-- Action for opening PR in browser
				["ctrl-o"] = function(selected)
					local pr_number = selected[1]:match("#(%d+)")
					if pr_number then
						vim.fn.system("gh pr view " .. pr_number .. " --web")
					end
				end,
			},
			fzf_opts = {
				["--header"] = [[
Enter: Checkout PR
Ctrl-D: Open in DiffView
Ctrl-O: Open in browser
]],
			}
		})
	end,
	{}
)
