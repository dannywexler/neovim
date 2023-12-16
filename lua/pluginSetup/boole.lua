require("boole").setup({
	mappings = {
		increment = "<C-n>",
		decrement = "<C-m>",
	},
	additions = {
		{ true, false },
		{ "let", "const" },
		{ "and", "or" },
		{ "&&", "||" },
	},
	-- allow_caps_additions = {
	-- { 'enable', 'disable' }
	-- enable → disable
	-- Enable → Disable
	-- ENABLE → DISABLE
	-- }
})
