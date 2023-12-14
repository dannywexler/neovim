local hooks = require("ibl.hooks")

hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)

local bar = "▏"
-- local bar = '▎'
require("ibl").setup({
	debounce = 100,
	indent = { char = bar },
	scope = { show_end = true },
	viewport_buffer = { min = 100, max = 600 },
})
