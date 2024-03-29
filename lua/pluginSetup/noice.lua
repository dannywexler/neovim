require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
		progress = {
			-- throttle = WINDOWS and 2000 or 300
			enabled = false,
		},
		signature = {
			auto_open = {
				throttle = WINDOWS and 300 or 50,
			},
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = true, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true, -- add a border to hover docs and signature help
	},
	routes = {
		{
			filter = {
				find = "splitkeep",
			},
			opts = { skip = true },
		},
		{
			filter = {
				event = "msg_show",
			},
			opts = { skip = true },
		},
	},
	views = {
		mini = {
			relative = "editor",
			align = "message-right",
			timeout = 4000,
			reverse = true,
			focusable = false,
			position = {
				row = -2,
				col = "100%",
				-- col = 0,
			},
			size = "auto",
			border = {
				style = "single",
			},
			zindex = 60,
			win_options = {
				winblend = 0,
				winhighlight = {
					Normal = "NoiceMini",
					IncSearch = "",
					Search = "",
				},
			},
		},
	},
})
