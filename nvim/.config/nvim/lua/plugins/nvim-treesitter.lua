return {
	"nvim-treesitter/nvim-treesitter",
	branch = 'main',
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require('nvim-treesitter').install({ "ruby", "lua", "javascript", "typescript", "rust" })

		vim.api.nvim_create_autocmd('FileType', {
			callback = function(args)
				if not pcall(vim.treesitter.start, args.buf) then
					return
				end
				-- Treesitter Ruby indent is buggy with method chains
				if vim.bo[args.buf].filetype ~= 'ruby' then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end
}
