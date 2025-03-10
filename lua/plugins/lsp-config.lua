local setup = function()
	require("mason").setup()
	require("mason-lspconfig").setup()

	-- Mappings.
	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	vim.api.nvim_create_user_command('DiagnosticFloat',
		function()
			vim.diagnostic.open_float()
		end, {})

	vim.api.nvim_create_user_command('DiagnosticList',
		function()
			vim.diagnostic.setloclist()
		end, {})

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	---@diagnostic disable-next-line: unused-local
	local on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

		-- Mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		local fzflua = require('fzf-lua');
		local fzflua_definitions = function()
			fzflua.lsp_definitions({ jump_to_single_result = true })
		end
		local fzflua_references = function()
			fzflua.lsp_references({ jump_to_single_result = true })
		end
		local fzflua_code_actions = function()
			fzflua.lsp_code_actions({})
		end
		--vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
		vim.keymap.set('n', 'gd', fzflua_definitions, bufopts)
		vim.keymap.set('n', 'gi', fzflua.lsp_implementations, bufopts)
		vim.keymap.set('n', 'gr', fzflua_references, bufopts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, bufopts)
		vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
		--vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
		--vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
		--vim.keymap.set('n', '<space>wl', function()
		--  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		--end, bufopts)
		--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
		--vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, bufopts)
		vim.keymap.set('n', 'ga', fzflua_code_actions, bufopts)
		--vim.keymap.set('n', '<space>fm', vim.lsp.buf.format, bufopts)
		vim.keymap.set('n', '=', vim.lsp.buf.format, bufopts)
	end

	-- local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

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
		on_attach = on_attach,
		settings = {
			intelephense = {
				-- possible values: stubs.txt
				stubs = {
					'Core',
					'Reflection',
					'SPL',
					'SimpleXML',
					'ctype',
					'date',
					'exif',
					'filter',
					'hash',
					'imagick',
					'json',
					'pcre',
					'random',
					'standard',
					"dom",
				}
			}
		}
	}

	require 'lspconfig'.gopls.setup {
		on_attach = on_attach,
	}

	require 'lspconfig'.volar.setup {
		filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
		on_attach = on_attach,
	}

	require('lspconfig').nil_ls.setup {
		on_attach = on_attach,
		settings = {
			['nil'] = {
				testSetting = 42,
				formatting = {
					command = { "nixfmt" },
				},
			},
		},
	}

	--rust
	require('lspconfig').rust_analyzer.setup {
		on_attach = on_attach,
	}

	require('lspconfig').bashls.setup {
		on_attach = on_attach,
	}
end


return {
	"neovim/nvim-lspconfig",
	config = setup,
}
