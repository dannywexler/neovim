return PLUG("windwp/nvim-autopairs", {
    event = "InsertEnter",
    main = "nvim-autopairs",
    opts = {
        -- switch for basic rule break undo sequence
        break_undo = true,
        check_ts = false,
        disable_filetype = { "snacks_picker_input" },
        -- disable when recording or executing a macro
        disable_in_macro = true,
        disable_in_replace_mode = true,
        -- disable when insert after visual block mode
        disable_in_visualblock = false,
        -- trigger abbreviation
        enable_abbr = false,
        -- add bracket pairs after quote
        enable_afterquote = true,
        enable_bracket_in_quote = true,
        --- check bracket in same line
        enable_check_bracket_line = true,
        enable_moveright = true,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        -- map the <BS> key
        map_bs = true,
        -- Map the <C-h> key to delete a pair
        map_c_h = false,
        -- map <c-w> to delete a pair if possible
        map_c_w = false,
        map_cr = true,
    }
})
