-- Set up autocommands to trigger checktime
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    -- Check if not in command-line mode before checking time
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
  desc = "Trigger autoread when file changes on disk",
})

-- Fix floating window border backgrounds to match the editor background.
-- gruvbox-material sets NormalFloat bg to a different color than Normal bg.
-- FloatBorder and FloatermBorder link to NormalFloat, inheriting that different
-- bg, which makes borders on floaterm, LSP hovers, etc. look mismatched.
-- We override their bg to match Normal. The link must be explicitly nilled out
-- because nvim_set_hl does not clear an existing link when setting attributes,
-- and links take precedence over explicit values at render time.
local function fix_float_borders()
  local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
  if not normal_bg then return end
  for _, group in ipairs({ "FloatBorder", "FloatermBorder" }) do
    local hl = vim.api.nvim_get_hl(0, { name = group })
    hl.link = nil
    hl.bg = normal_bg
    vim.api.nvim_set_hl(0, group, hl)
  end
end
fix_float_borders()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = fix_float_borders,
  desc = "Fix floating window border backgrounds to match editor background",
})

-- Add a notification after a file reload
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None',
  desc = "Notify user after file change and reload",
})

