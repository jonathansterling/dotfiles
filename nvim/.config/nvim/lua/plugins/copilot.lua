return {
	"github/copilot.vim",
	lazy = false,
	enabled = true,
	config = function()
		-- Disable the default Tab mapping
		vim.g.copilot_no_tab_map = true
		-- Map Shift+Tab to accept copilot suggestions
		vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false
		})
		-- Map Ctrl+Tab to cycle through copilot suggestions
		-- vim.keymap.set('i', '<S-n>', '<Plug>(copilot-next)')
	end,
}

