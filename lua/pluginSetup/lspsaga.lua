require 'lspsaga'.setup {
    beacon = {
        enable = false,
        frequency = 7,
    },
    callhierarchy = {
        show_detail = false,
        keys = {
            edit = "e",
            expand_collapse = "u",
            jump = "o",
            quit = "q",
            split = "i",
            tabe = "t",
            vsplit = "s",
        },
    },
    code_action = {
        extend_gitsigns = false,
        keys = { quit = "q", exec = "<CR>" },
        num_shortcut = true,
        show_server_name = false,
    },
    -- diagnostic = {
    --     border_follow = true,
    --     custom_fix = nil,
    --     custom_msg = nil,
    --     jump_num_shortcut = true,
    --     keys = { exec_action = "o", go_action = "g", quit = "q" },
    --     max_width = 0.8,
    --     on_insert = false,
    --     on_insert_follow = false,
    --     show_code_action = true,
    --     show_source = false,
    --     text_hl_follow = false,
    -- },
    diagnostic = {
        border_follow = true,
        extend_relatedInformation = false,
        insert_winblend = 0,
        jump_num_shortcut = true,
        max_height = 0.5,
        max_show_height = 0.5,
        max_show_width = 0.8,
        max_width = 0.8,
        on_insert = false,
        on_insert_follow = false,
        show_code_action = true,
        show_source = false,
        text_hl_follow = false,
        keys = {
            exec_action = 'o',
            expand_or_jump = '<CR>',
            go_action = 'g',
            quit = 'q',
            quit_in_show = { 'q', '<ESC>' },
        },
    },
    lightbulb = {
        enable = true,
        enable_in_insert = false,
        virtual_text = true,
        sign = false,
    },
    outline = {
        auto_close = true,
        auto_preview = true,
        auto_refresh = true,
        custom_sort = nil,
        keys = { jump = "o", expand_collapse = "u", quit = "q" },
        show_detail = true,
        win_position = "right",
        win_width = 30,
        win_with = "",
    },
    symbol_in_winbar = {
        color_mode = true,
        enable = false,
        folder_level = 2,
        hide_keyword = true,
        ignore_patterns = {},
        respect_root = false,
        separator = " ",
        show_file = true,
    },
    ui = {
        border = "rounded",
        code_action = "💡",
        collapse = "",
        expand = "",
        hover = ' ',
        incoming = " ",
        kind = {},
        outgoing = " ",
        -- This option only works in Neovim 0.9
        title = true,
        winblend = 0,
    },
}
