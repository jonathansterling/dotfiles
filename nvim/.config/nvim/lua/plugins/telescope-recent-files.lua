return {
  "smartpde/telescope-recent-files",
	lazy = false,
	dependencies = "nvim-telescope/telescope.nvim",
	config = function()
		require("telescope").setup({
			extensions = {
				recent_files = {
					only_cwd = true
				}
			}
		})
		require("telescope").load_extension("recent_files")
	end
}

