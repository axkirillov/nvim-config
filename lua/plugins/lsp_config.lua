require("mason").setup()
require("mason-lspconfig").setup()

-- NEODEV
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	local telescope_builtin = require('telescope.builtin');
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	--vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations, bufopts)
	vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	--vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	--vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	--vim.keymap.set('n', '<space>wl', function()
	--  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	--end, bufopts)
	--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, bufopts)
	--vim.keymap.set('n', '<space>fm', vim.lsp.buf.format, bufopts)
	vim.keymap.set('n', '=', vim.lsp.buf.format, bufopts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require 'lspconfig'.lua_ls.setup {
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			},
			completion = {
				callSnippet = "Replace"
			}
		}
	}
}

require 'lspconfig'.intelephense.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		intelephense = {
			-- possible values: stubs.txt
			stubs = {
				'Core',
				'SPL',
				'imagick',
				'standard',
				'pcre',
				'date',
				'json',
				'ctype',
				'SimpleXML',
				'Reflection',
			}
		}
	}
}

require 'lspconfig'.gopls.setup {
	on_attach = on_attach,
}

--require 'lspconfig'.tsserver.setup {
--	on_attach = on_attach,
--}

require 'lspconfig'.terraformls.setup {
	on_attach = on_attach
}

require 'lspconfig'.volar.setup {
	filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
	on_attach = on_attach,
}
