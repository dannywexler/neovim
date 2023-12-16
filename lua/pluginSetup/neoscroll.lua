require("neoscroll").setup({
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	easing_function = "sine", -- Default easing function
	hide_cursor = true, -- Hide cursor while scrolling
	mappings = {},
	performance_mode = false, -- Disable "Performance Mode" on all buffers.
	post_hook = nil, -- Function to run after the scrolling animation ends
	pre_hook = nil, -- Function to run before the scrolling animation starts
	respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	stop_eof = true, -- Stop at <EOF> when scrolling downwards
})
