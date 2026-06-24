return {
	"ErichDonGubler/lsp_lines.nvim",
	lazy = false,
	config = function()
		require("lsp_lines").setup()
		vim.diagnostic.config({ virtual_lines = true })
	end,
}
