return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	lazy = false,
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		local config = require("telescope")
		local pickers = require("config.telescope-pickers")
		config.setup({
			pickers = {
				lsp_references = {
					layout_strategy = "vertical",
					layout_config = {
						preview_height = 0.75,
					},
				},
				live_grep = {
					layout_strategy = "vertical",
					layout_config = {
						preview_height = 0.75,
					},
					mappings = {
						i = { ["<C-s>"] = pickers.toggle_specs("live_grep") },
						n = { ["<C-s>"] = pickers.toggle_specs("live_grep") },
					},
				},
				find_files = {
					layout_strategy = "vertical",
					layout_config = {
						preview_height = 0.75,
					},
					mappings = {
						i = { ["<C-s>"] = pickers.toggle_specs("find_files") },
						n = { ["<C-s>"] = pickers.toggle_specs("find_files") },
					},
				},
				git_status = {
					layout_strategy = "vertical",
					layout_config = {
						preview_height = 0.75,
					},
				},
			},
		})
	end
}

