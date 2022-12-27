require'nvim-tree'.setup {
    disable_netrw = true,
    hijack_cursor = true,
    live_filter = {
        prefix = 'FILTER: ',
        always_show_folders = false
    },
    renderer = {
        group_empty = true,
        -- highlight_opened_files = 'name',
        icons = {
            git_placement = 'after'
        },
        indent_width = 1,
        indent_markers = {
            enable = true
        },
        -- root_folder_label = ":~:s?$?/..?",
        root_folder_label = ":~:s?$?",
    },
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
        debounce_delay = 100,
    },
    view = {
        hide_root_folder = false,
        mappings = {
            list = {
                { key = 'i', action = 'cd' },
                { key = 'n', action = 'expand_all' },
                { key = 'N', action = 'collapse_all' },
                { key = 'u', action = 'dir_up' },
                { key = "<C-e>", action = "" },
                { key = "?", action = "toggle_help" },
            }
        },
        signcolumn = 'no',
        width = 35
    },
}
