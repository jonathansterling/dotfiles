return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Suppress deprecation warning
		vim.deprecate = function() end

		local lspconfig = require("lspconfig")

		-- This function will be called when an LSP server connects to a buffer
		local on_attach = function(client, bufnr)
			-- Check if server supports documentHighlight capability
			if client.server_capabilities.documentHighlightProvider then
				local augroup = vim.api.nvim_create_augroup('LspDocumentHighlight', { clear = false })
				vim.api.nvim_create_autocmd('CursorHold', {
					group = augroup,
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd('CursorMoved', {
					group = augroup,
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end

		-- Ruby LSP setup
		local ruby_lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
		ruby_lsp_capabilities.general = { positionEncodings = { "utf-16" } }
		lspconfig.ruby_lsp.setup({
			autostart = true,
			capabilities = ruby_lsp_capabilities,
			on_attach = on_attach,
			init_options = {
				enabledFeatures = {
					diagnostics = true,
				},
				linters = { "rubocop" },
			},
			handlers = {
				-- The Rails addon asks to run pending migrations via a blocking
				-- prompt; show it as a passive fidget toast instead and tell the
				-- server the prompt was dismissed.
				["window/showMessageRequest"] = function(err, result, ctx)
					if result and result.message:lower():find("migration") then
						local count = result.message:match("(%d+) pending migration")
						local msg = count and string.format("Pending %s migration%s", count, count == "1" and "" or "s")
							or "Pending migrations"
						require("fidget").notify(msg, vim.log.levels.WARN)
						return vim.NIL
					end
					return vim.lsp.handlers["window/showMessageRequest"](err, result, ctx)
				end,
			},
		})

		-- Clangd setup
		lspconfig.clangd.setup({
			autostart = true,
			on_attach = on_attach,
		})

		-- Rust Analyzer setup
		lspconfig.rust_analyzer.setup({
			autostart = true,
			on_attach = on_attach,
			capabilities = require('cmp_nvim_lsp').default_capabilities(),
			settings = {
				['rust-analyzer'] = {
					check = {
						command = "clippy" -- Use clippy for more thorough linting
					},
					cargo = {
						allFeatures = true,
					},
				}
			}
		})
	end,
}

