local setup = function()
	require("mason").setup()

	local ensure_installed
	if vim.fn.has("nvim-0.11") == 1 then
		ensure_installed = {
			"lua_ls",
			"intelephense",
			"gopls",
			"vue_ls",
			"vtsls",
			"nil_ls",
			"rust_analyzer",
			"bashls",
		}
	else
		ensure_installed = {
			"lua_ls",
			"intelephense",
			"gopls",
			"volar",
			"nil_ls",
			"rust_analyzer",
			"bashls",
		}
	end

	require("mason-lspconfig").setup({
		ensure_installed = ensure_installed,
		-- We'll enable servers explicitly below.
		automatic_enable = false,
	})

	-- Mappings.
	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	vim.api.nvim_create_user_command(
		'DiagnosticFloat',
		function() vim.diagnostic.open_float() end,
		{}
	)

	vim.api.nvim_create_user_command(
		'DiagnosticList',
		function() vim.diagnostic.setloclist() end,
		{}
	)

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
			fzflua.lsp_definitions({ jump1 = true })
		end
		local fzflua_references = function()
			fzflua.lsp_references({ jump1 = true })
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

	if vim.fn.has("nvim-0.11") == 1 then
		-- Nvim 0.11+ uses vim.lsp.config()/vim.lsp.enable().
		-- nvim-lspconfig provides the default configs via runtime `lsp/<name>.lua`.
		local function extend_config(name, cfg)
			local base = vim.lsp.config[name] or {}
			vim.lsp.config(name, vim.tbl_deep_extend("force", base, cfg))
		end

		extend_config("lua_ls", {
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		extend_config("intelephense", {
			on_attach = on_attach,
			settings = {
				intelephense = {
					-- possible values: stubs.txt
					stubs = {
						"Core",
						"Reflection",
						"SPL",
						"SimpleXML",
						"ctype",
						"date",
						"exif",
						"filter",
						"hash",
						"imagick",
						"json",
						"pcre",
						"random",
						"standard",
						"dom",
					},
				},
			},
		})

		extend_config("gopls", {
			on_attach = on_attach,
		})

		extend_config("vue_ls", {
			on_attach = on_attach,
		})

		-- Vue SFC TypeScript support for vue_ls (requires @vue/typescript-plugin from vue-language-server).
		local vue_language_server_path = vim.fn.stdpath("data")
			.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
		local vue_plugin = {
			name = "@vue/typescript-plugin",
			location = vue_language_server_path,
			languages = { "vue" },
			configNamespace = "typescript",
		}

		extend_config("vtsls", {
			on_attach = on_attach,
			-- Extend to include Vue SFC.
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							vue_plugin,
						},
					},
				},
			},
		})

		extend_config("nil_ls", {
			on_attach = on_attach,
			settings = {
				["nil"] = {
					testSetting = 42,
					formatting = {
						command = { "nixfmt" },
					},
				},
			},
		})

		extend_config("rust_analyzer", {
			on_attach = on_attach,
		})

		extend_config("bashls", {
			on_attach = on_attach,
		})

		vim.lsp.enable({
			"lua_ls",
			"intelephense",
			"gopls",
			"vue_ls",
			"vtsls",
			"nil_ls",
			"rust_analyzer",
			"bashls",
		})
	else
		require('lspconfig').lua_ls.setup({
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = {
						globals = { 'vim' },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		require('lspconfig').intelephense.setup({
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
					},
				},
			},
		})

		require('lspconfig').gopls.setup({
			on_attach = on_attach,
		})

		require('lspconfig').volar.setup({
			filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
			on_attach = on_attach,
		})

		require('lspconfig').nil_ls.setup({
			on_attach = on_attach,
			settings = {
				['nil'] = {
					testSetting = 42,
					formatting = {
						command = { "nixfmt" },
					},
				},
			},
		})

		require('lspconfig').rust_analyzer.setup({
			on_attach = on_attach,
		})

		require('lspconfig').bashls.setup({
			on_attach = on_attach,
		})
	end
end


return {
	"neovim/nvim-lspconfig",
	config = setup,
}
