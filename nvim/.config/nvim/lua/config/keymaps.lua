-- tmux keybindings can be found in ~/.tmux.conf

-- Leader Key (Command) overrides for iTerm 2. See Settings > Keys
-- Terminal Emulator does not pass Command hotkeys so we hack these in
vim.api.nvim_set_keymap('n', '++', 'gcc', { silent = true })
vim.api.nvim_set_keymap('v', '++', 'gc', { silent = true })

-- 'Space + p' opens file structure navigation
vim.keymap.set("n", "<leader>p", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle Project Pane" })

-- 'Space + f' opens Telescope fuzzy file name search
vim.keymap.set("n", "<leader>f", function() require("config.telescope-pickers").find_files() end, { silent = false, desc = "Find Files"})

-- 'Space + Shift + f opens Telescope live_grep'
vim.keymap.set("n", "<leader>F", function() require("config.telescope-pickers").live_grep() end, { silent = false, desc = "Live Grep" })

-- 'Space + e' opens recent files
vim.keymap.set("n", "<leader>e", [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]], { noremap = true, silent = true , desc = "Recent Files"})

-- 'Space + g' opens changed or new files (git status)
vim.keymap.set("n", "<leader>g", ":Telescope git_status<CR>", { noremap = true, silent = true, desc = "Git Status" })

-- 'Space + d' goes to definition
vim.keymap.set('n', '<leader>d', require('telescope.builtin').lsp_definitions, { noremap = true, silent = true, desc = "Go To Definition" })

-- 'Space + Shift + d' goes to definition in a new tab
vim.keymap.set('n', '<leader>D', function()
	require('telescope.builtin').lsp_definitions({ jump_type = 'tab' })
end, { noremap = true, silent = true, desc = "Go To Definition (New Tab)" })

-- 'Space + r' finds references
vim.keymap.set('n', '<leader>r', function()
	local builtin = require('telescope.builtin')
	builtin.lsp_references({
		entry_maker = function(entry)
			local filename = vim.fn.fnamemodify(entry.filename or entry.uri, ':.')
			return {
				value = entry,
				ordinal = filename, -- for sorting/filtering
				display = filename, -- show path relative to cwd
				filename = entry.filename or entry.uri,
				lnum = entry.lnum,
				col = entry.col,
			}
		end,
	})
end, { noremap = true, silent = true, desc = "Find References" })

-- 'Space + {' and 'Space + }' to jump back and forward in jump list
vim.keymap.set('n', '<leader>{', '<C-o>', { desc = "Jump Backwards"})
vim.keymap.set('n', '<leader>}', '<C-i>', { desc = "Jump Forwards"})

-- 'Space + [' and 'Space + ]' to navigate tabs
vim.keymap.set('n', '<leader>[', ':tabp<CR>', { desc = "Previous Tab"})
vim.keymap.set('n', '<leader>]', ':tabn<CR>', { desc = "Next Tab"})

-- 'Space + c' copies current file path to clipboard
vim.keymap.set('n', '<leader>c', ':let @+=expand("%")<CR>', { desc = "Copy File Path" })

-- 'Ctrl + Space' shows auto-complete options
vim.keymap.set('i', '<C-Space>', function() require('cmp').complete() end, { desc = "Show Auto-Complete Menu" })

-- 'Esc' in normal mode clears search highlighting
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear Search Highlight" })

-- 'Space + h' toggles diagnostics
vim.keymap.set('n', '<leader>h', function()
	if vim.diagnostic.is_disabled() then
		vim.diagnostic.enable()
		print("Diagnostics enabled")
	else
		vim.diagnostic.disable()
		print("Diagnostics disabled")
	end
end, { noremap = true, silent = false, desc = "Toggle Diagnostics" })

-- nvim-test
vim.keymap.set('n', '<leader>t', ':TestNearest<CR>', { desc = "Test Nearest" })
vim.keymap.set('n', '<leader>T', ':TestFile<CR>', { desc = "Test File" })
vim.keymap.set('n', '<leader>y', ':TestLast<CR>', { desc = "Test Last" })
vim.keymap.set('n', '<leader>Y', ':TestVisit<CR>', { desc = "Test Visit" })

