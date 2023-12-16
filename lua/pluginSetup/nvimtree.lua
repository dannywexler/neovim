require("nvim-tree").setup({
	auto_reload_on_write = not WINDOWS,
	disable_netrw = true,
	hijack_cursor = true,
	filesystem_watchers = {
		enable = false,
	},
	live_filter = {
		prefix = "FILTER: ",
		always_show_folders = false,
	},
	reload_on_bufenter = false,
	renderer = {
		group_empty = true,
		-- highlight_opened_files = 'name',
		icons = {
			git_placement = "after",
		},
		indent_width = 2,
		indent_markers = {
			enable = true,
		},
		-- root_folder_label = ":~:s?$?/..?",
		-- root_folder_label = ":~:s?$?",
		root_folder_label = false,
	},
	sync_root_with_cwd = true,
	update_focused_file = {
		enable = false,
	},
	view = {
		debounce_delay = 100,
		-- mappings = {
		--     list = {
		--         { key = 'i', action = 'cd' },
		--         { key = 'n', action = 'expand_all' },
		--         { key = 'N', action = 'collapse_all' },
		--         { key = 'u', action = 'dir_up' },
		--         { key = "<C-e>", action = "" },
		--         { key = "?", action = "toggle_help" },
		--     }
		-- },
		signcolumn = "no",
		width = 35,
	},
})
