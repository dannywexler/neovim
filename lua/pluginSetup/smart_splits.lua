require("smart-splits").setup({
	-- Ignored buffer types (only while resizing)
	ignored_buftypes = {
		"nofile",
		"quickfix",
		"prompt",
	},
	-- Ignored filetypes (only while resizing)
	ignored_filetypes = { "NvimTree" },
	-- the default number of lines/columns to resize by at a time
	default_amount = 3,
	-- Desired behavior when your cursor is at an edge and you
	-- are moving towards that same edge:
	-- 'wrap' => Wrap to opposite side
	-- 'split' => Create a new split in the desired direction
	-- 'stop' => Do nothing
	at_edge = "split",
	-- when moving cursor between splits left or right,
	-- place the cursor on the same row of the *screen*
	-- regardless of line numbers. False by default.
	-- Can be overridden via function parameter, see Usage.
	move_cursor_same_row = false,
	-- whether the cursor should follow the buffer when swapping
	-- buffers by default; it can also be controlled by passing
	-- `{ move_cursor = true }` or `{ move_cursor = false }`
	-- when calling the Lua function.
	cursor_follows_swapped_bufs = true,
})
