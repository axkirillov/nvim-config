local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local proc = vim.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	}, { text = true })
	local res = proc:wait()
	if res.code ~= 0 then
		vim.api.nvim_err_writeln("Failed to clone lazy.nvim")
		if res.stderr and res.stderr ~= "" then
			vim.api.nvim_err_writeln(res.stderr)
		end
	end
end
vim.opt.rtp:prepend(lazypath)
