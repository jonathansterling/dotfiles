return {
	"vim-test/vim-test",
  lazy = false,
  config = function()
    vim.g['test#strategy'] = 'floaterm'
  end,
}

