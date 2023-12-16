require("searchbox").setup({
	defaults = {
		clear_matches = false,
		confirm = "menu",
		exact = false,
		modifier = "case-sensitive",
		prompt = " ",
		reverse = false,
		show_matches = true,
		title = " Search ",
	},
	popup = {
		relative = "win",
		position = {
			row = "1",
			col = "99%",
		},
		size = 30,
		border = {
			style = "rounded",
			text = {
				top = " Search ",
				top_align = "left",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	},
})
