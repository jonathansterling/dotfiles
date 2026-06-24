-- Configure LSP diagnostics display
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
})

-- Disable diagnostics by default
vim.diagnostic.disable()

