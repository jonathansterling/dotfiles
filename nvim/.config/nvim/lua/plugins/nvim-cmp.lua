return {
  "hrsh7th/nvim-cmp", -- Completion Plugin
  dependencies = {
    "hrsh7th/cmp-buffer",      -- Buffer completions
    "hrsh7th/cmp-path",        -- Path completions
    "hrsh7th/cmp-cmdline",     -- Command-line completions
		'hrsh7th/cmp-nvim-lsp',    -- LSP completions
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        -- ["<C-Space>"] = cmp.mapping.complete(), -- Show completion menu
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Confirm selection
        -- ["<Tab>"] = cmp.mapping.select_next_item(), -- Next item
        -- ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Previous item
      }),
      sources = cmp.config.sources({
        { name = "buffer" },   -- Buffer suggestions
        { name = "path" },     -- File path suggestions
				{ name = "nvim_lsp" }, -- LSP suggestions
      }),
    })
  end
}

