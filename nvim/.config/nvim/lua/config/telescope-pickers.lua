-- find_files/live_grep wrappers with a toggle to hide rspec files.
-- <C-s> inside either picker flips the filter and reruns the search in place.
local M = {}

M.hide_specs = false

local spec_patterns = { "_spec%.rb$", "^spec/", "/spec/" }

local function with_spec_filter(opts, title)
	opts = opts or {}
	if M.hide_specs then
		opts.file_ignore_patterns = spec_patterns
		opts.prompt_title = title .. " (specs hidden)"
	end
	return opts
end

function M.find_files(opts)
	require("telescope.builtin").find_files(with_spec_filter(opts, "Find Files"))
end

function M.live_grep(opts)
	require("telescope.builtin").live_grep(with_spec_filter(opts, "Live Grep"))
end

-- Builds the in-picker action: flip the filter and relaunch the same
-- picker, preserving whatever was typed in the prompt
function M.toggle_specs(picker_name)
	return function(prompt_bufnr)
		M.hide_specs = not M.hide_specs
		local line = require("telescope.actions.state").get_current_line()
		require("telescope.actions").close(prompt_bufnr)
		M[picker_name]({ default_text = line })
	end
end

return M
