return PLUG("karb94/neoscroll.nvim", {
    lazy = true,
    opts = {
        mappings = {},
        -- The cursor will keep on scrolling even if the window cannot scroll further
        cursor_scrolls_alone = true,
        -- Global duration multiplier
        duration_multiplier = 1.0,
        -- Easing functions: linear, quadratic, cubic, quartic, quintic, circular, sine
        easing = 'circular',
        -- Hide cursor while scrolling
        hide_cursor = true,
        -- Events ignored while scrolling
        ignored_events = { 'WinScrolled', 'CursorMoved' },
        -- Disable "Performance Mode" on all buffers.
        performance_mode = false,
        -- Function to run after the scrolling animation ends
        post_hook = nil,
        -- Function to run before the scrolling animation starts
        pre_hook = nil,
        -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        respect_scrolloff = false,
        -- Stop at <EOF> when scrolling downwards
        stop_eof = true,
    }
})
