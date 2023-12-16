require("bufferline").setup({
	highlights = {
		background = { fg = "#b8bdd1" },
		buffer_visible = {
			fg = "#b8bdd1",
			-- fg = '#1a1b26',
			bold = true,
			italic = false,
		},
		buffer_selected = {
			fg = "#00ffcc",
			-- fg = '#1a1b26',
			bold = true,
			italic = false,
		},
		modified_selected = {
			fg = "#f14c28",
		},
		tab = {
			bg = "#7aa2f7",
			fg = "#000000",
			bold = true,
			italic = false,
		},
		tab_selected = {
			bg = "#00ffcc",
			fg = "#000000",
			bold = true,
			italic = false,
		},
		pick = {
			fg = "#f14c28",
			bold = true,
			italic = false,
		},
		pick_visible = {
			fg = "#f14c28",
			bold = true,
			italic = false,
		},
		pick_selected = {
			fg = "#f14c28",
			bold = true,
			italic = false,
		},
		separator_selected = {
			fg = "#00ffcc",
		},
		indicator_selected = {
			fg = "#00ffcc",
			bg = "#00ffcc",
		},
	},
	options = {
		enforce_regular_tabs = false,
		max_name_length = 40,
		max_prefix_length = 24,
		numbers = "none",
		offsets = {
			{
				filetype = "NvimTree",
				-- text = function()
				--     return vim.fn.getcwd()
				-- end,
				text = "File Tree",
				highlight = "Directory",
				text_align = "center",
				separator = true,
			},
		},
		persist_buffer_sort = true,
		separator_style = "thick",
		show_buffer_close_icons = false,
		show_close_icon = false,
		show_tab_indicators = true,
		-- sort_by = function(buffer_a, buffer_b)
		--     -- print(vim.inspect(buffer_a))
		--     -- add custom logic
		--     return buffer_a.modified > buffer_b.modified
		-- end,
		tab_size = 8,
	},
})
