require 'bufferline'.setup {
    highlights = {
        buffer_selected = {
            fg = '#7aa2f7',
            -- fg = '#1a1b26',
            bold = true,
            italic = false
        },
        tab_selected = {
            bg = '#7aa2f7',
            fg = '#1a1b26',
            bold = true,
            italic = false
        },
        pick = {
            fg = '#00ffcc',
            bold = true,
            italic = false,
        },
        pick_visible = {
            fg = '#00ffcc',
            bold = true,
            italic = false,
        },
        pick_selected = {
            fg = '#00ffcc',
            bold = true,
            italic = false,
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
                text = 'File Tree',
                highlight = "Directory",
                text_align = "left",
                separator = true
            }
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
    }
}
