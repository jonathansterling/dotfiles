return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
			update_focused_file = {
				enable = true,
				update_root = true,
			},
			view = {
				width = {
					min = 30,
					max = -1,
				},
			},
		}
  end,
}

