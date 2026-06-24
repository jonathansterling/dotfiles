return {
	"j-hui/fidget.nvim",
	lazy = false,
	opts = {
		notification = {
			window = {
				normal_hl = "Normal",     -- highlight group for notifications
				winblend = 20,            -- pseudo-transparency for floating window
				border = "rounded",       -- style of border
			},
		},
		progress = {
			ignore_done_already = false, -- show old tasks briefly
		},
	},
	config = function(_, opts)
		require("fidget").setup(opts)

		-- Servers only report $/progress for their own background work (indexing etc.),
		-- so slow client-initiated requests like ruby-lsp reference lookups give no
		-- feedback. Bridge the LspRequest autocmd into fidget spinners for them.
		local watched = {
			["textDocument/references"] = "references",
			["textDocument/definition"] = "definition",
			["textDocument/implementation"] = "implementation",
			["textDocument/typeDefinition"] = "type definition",
			["workspace/symbol"] = "workspace symbols",
			["callHierarchy/incomingCalls"] = "incoming calls",
			["callHierarchy/outgoingCalls"] = "outgoing calls",
			["textDocument/rename"] = "rename",
		}
		local handles = {}
		vim.api.nvim_create_autocmd("LspRequest", {
			group = vim.api.nvim_create_augroup("FidgetLspRequest", {}),
			callback = function(args)
				local title = watched[args.data.request.method]
				if not title then
					return
				end
				local key = args.data.client_id .. ":" .. args.data.request_id
				if args.data.request.type == "pending" then
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					handles[key] = require("fidget.progress.handle").create({
						title = title,
						message = "waiting…",
						lsp_client = { name = client and client.name or "lsp" },
					})
				elseif handles[key] then
					local handle = handles[key]
					handles[key] = nil
					if args.data.request.type == "cancel" then
						handle:cancel()
					else
						handle.message = "done"
						handle:finish()
					end
				end
			end,
		})
	end,
}

