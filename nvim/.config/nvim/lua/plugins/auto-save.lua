return {
	"Pocco81/auto-save.nvim",
	lazy = false,
	config = function()
		require("auto-save").setup({
			condition = function(buf)
				-- Disable auto-save for migration files
				return not vim.fn.expand("%:p"):match("/db/migrate/")
			end,
		})
	end
}

