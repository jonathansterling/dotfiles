return {
	"nvim-treesitter/nvim-treesitter",
	branch = 'master',
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require('nvim-treesitter.configs').setup({
			ensure_installed = { "ruby", "lua", "javascript", "typescript", "rust" },
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false
			},
			indent = {
				enable = true,
				disable = { "ruby" }  -- Treesitter Ruby indent is buggy with method chains
			}
		})
	end
}

