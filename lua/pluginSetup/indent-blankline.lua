local hooks = require("ibl.hooks")

local indent_highlights = {
	"#7aa2f7",
	"#5f43e9",
	"#2ac3de",
	"#e0af68",
	"#c678dd",
	"#EEF06D",
}

local indent_names = {}
for i = 1, #indent_highlights do
	local name = "Indent" .. tostring(i)
	table.insert(indent_names, name)
end

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	for index, hl_color in ipairs(indent_highlights) do
		vim.api.nvim_set_hl(0, indent_names[index], { fg = hl_color })
	end
end)

hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)

hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

local bar = "▏"
-- local bar = '▎'
require("ibl").setup({
	debounce = 100,
	indent = {
		char = bar,
		highlight = indent_names,
	},
	scope = { show_end = true },
	viewport_buffer = { min = 100, max = 600 },
})
