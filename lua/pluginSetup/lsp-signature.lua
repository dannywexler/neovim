require("lsp_signature").setup({
	bind = true,
	doc_lines = 2,
	handler_opts = {
		border = "rounded",
	},
	hint_enable = false,
	hint_prefix = "P ",
	hi_parameter = "Visual",
	max_height = 4,
	max_width = 160,
	wrap = true,
})
