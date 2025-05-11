return PLUG("nvim-neo-tree/neo-tree.nvim", {
    cmd = { "Neotree" },
    dependencies = {
        PLUG(
            "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
            {
                opts = {
                    filter_rules = {
                        autoselect_one = true,
                        bo = {
                            filetype = { "neo-tree", "neo-tree-popup", "notify" },
                            buftype = { "terminal", "quickfix" },
                        },
                        include_current_win = false,
                    },
                }
            })
    },
    opts = {
        add_blank_line_at_top = false,           -- Add a blank line at the top of the tree.
        auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
        close_if_last_window = true,             -- Close Neo-tree if it is the last window left in the tab
        default_source = "filesystem",           -- you can choose a specific source `last` here which indicates the last used source
        enable_cursor_hijack = false,            -- If enabled neotree will keep the cursor on the first letter of the filename when moving in the tree.
        enable_diagnostics = false,
        enable_git_status = false,
        enable_modified_markers = false, -- Show markers for files with unsaved changes.
        enable_opened_markers = false,   -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
        enable_refresh_on_write = false, -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
        git_status_async = true,
        -- These options are for people with VERY large git repos
        git_status_async_options = {
            batch_size = 1000, -- how many lines of git status results to process at a time
            batch_delay = 10,  -- delay in ms between batches. Spreads out the workload to let other processes run.
            max_lines = 10000, -- How many lines of git status results to process. Anything after this will be dropped.
            -- Anything before this will be used. The last items to be processed are the untracked files.
        },
        hide_root_node = true,                                                     -- Hide the root node.
        log_level = "info",                                                        -- "trace", "debug", "info", "warn", "error", "fatal"
        log_to_file = false,                                                       -- true, false, "/path/to/file.log", use ':lua require("neo-tree").show_logs()' to show the file
        open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" }, -- when opening files, do not use windows containing these filetypes or buftypes
        open_files_in_last_window = true,                                          -- false = open files in top left window
        open_files_using_relative_paths = true,
        -- popup_border_style is for input and confirmation dialogs.
        -- Configurtaion of floating window is done in the individual source sections.
        -- "NC" is a special style that works well with NormalNC set
        popup_border_style = "NC",         -- "double", "rounded", "single", "solid", (or "" to use 'winborder' on Neovim v0.11+)
        resize_timer_interval = 500,       -- in ms, needed for containers to redraw right aligned and faded content. Set to -1 to disable the resize timer entirely. NOTE: this will speed up to 50 ms for 1 second following a resize
        retain_hidden_root_indent = false, -- IF the root node is hidden, keep the indentation anyhow. This is needed if you use expanders because they render in the indent.
        sort_case_insensitive = false,     -- used when sorting files and directories in the tree
        sort_function = nil,               -- uses a custom function for sorting files and directories in the tree
        use_default_mappings = true,
        use_popups_for_input = true,       -- If false, inputs will use vim.ui.input() instead of custom floats.

        sources = {
            "filesystem",
            -- "buffers",
            -- "git_status",
            -- "document_symbols",
        },

        default_component_configs = {
            container = {
                enable_character_fade = true,
                width = "100%",
                right_padding = 0,
            },
            --diagnostics = {
            --  symbols = {
            --    hint = "H",
            --    info = "I",
            --    warn = "!",
            --    error = "X",
            --  },
            --  highlights = {
            --    hint = "DiagnosticSignHint",
            --    info = "DiagnosticSignInfo",
            --    warn = "DiagnosticSignWarn",
            --    error = "DiagnosticSignError",
            --  },
            --},
            indent = {
                indent_size = 2,
                padding = 1,
                -- indent guides
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                -- expander config, needed for nesting files
                with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "󰉖",
                folder_empty_open = "󰷏",
                -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                -- then these will never be used.
                default = "*",
                highlight = "NeoTreeFileIcon",
                provider = function(icon, node, _) -- 3rd param is "state" with lots of info
                    if node.type == "file" then
                        local icn, hl = require("mini.icons").get(node.type, node.path)
                        -- LOG("FILE type:", node.type, "path:", node.path, "icn:", icn, " hl:", hl)
                        icon.text = icn
                        icon.highlight = hl
                    end
                end,
            },
            modified = {
                symbol = "[+] ",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                highlight_opened_files = false, -- Requires `enable_opened_markers = true`.
                -- Take values in { false (no highlight), true (only loaded),
                -- "all" (both loaded and unloaded)}. For more information,
                -- see the `show_unloaded` config of the `buffers` source.
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                    -- Change type
                    added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
                    deleted   = "✖",
                    modified  = "",
                    renamed   = "󰁕",
                    -- Status type
                    untracked = "",
                    ignored   = "",
                    unstaged  = "󰄱",
                    staged    = "",
                    conflict  = "",
                },
                align = "right",
            },
            -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
            file_size = {
                enabled = false,
                width = 12,          -- width of the column
                required_width = 64, -- min width of window required to show this column
            },
            type = {
                enabled = false,
                width = 10,           -- width of the column
                required_width = 110, -- min width of window required to show this column
            },
            last_modified = {
                enabled = false,
                width = 20,                   -- width of the column
                required_width = 88,          -- min width of window required to show this column
                format = "%Y-%m-%d %I:%M %p", -- format string for timestamp (see `:h os.date()`)
                -- or use a function that takes in the date in seconds and returns a string to display
                --format = require("neo-tree.utils").relative_date, -- enable relative timestamps
            },
            created = {
                enabled = false,
                width = 20,                   -- width of the column
                required_width = 120,         -- min width of window required to show this column
                format = "%Y-%m-%d %I:%M %p", -- format string for timestamp (see `:h os.date()`)
                -- or use a function that takes in the date in seconds and returns a string to display
                --format = require("neo-tree.utils").relative_date, -- enable relative timestamps
            },
            symlink_target = {
                enabled = false,
                text_format = " ➛ %s", -- %s will be replaced with the symlink target's path.
            },
        },
        renderers = {
            directory = {
                { "indent" },
                { "icon" },
                { "current_filter" },
                {
                    "container",
                    content = {
                        { "name",          zindex = 10 },
                        {
                            "symlink_target",
                            zindex = 10,
                            highlight = "NeoTreeSymbolicLinkTarget",
                        },
                        { "clipboard",     zindex = 10 },
                        { "diagnostics",   errors_only = true, zindex = 20,     align = "right",          hide_when_expanded = true },
                        { "git_status",    zindex = 10,        align = "right", hide_when_expanded = true },
                        { "file_size",     zindex = 10,        align = "right" },
                        { "type",          zindex = 10,        align = "right" },
                        { "last_modified", zindex = 10,        align = "right" },
                        { "created",       zindex = 10,        align = "right" },
                    },
                },
            },
            file = {
                { "indent" },
                { "icon" },
                {
                    "container",
                    content = {
                        {
                            "name",
                            zindex = 10
                        },
                        {
                            "symlink_target",
                            zindex = 10,
                            highlight = "NeoTreeSymbolicLinkTarget",
                        },
                        { "clipboard",     zindex = 10 },
                        { "bufnr",         zindex = 10 },
                        { "modified",      zindex = 20, align = "right" },
                        { "diagnostics",   zindex = 20, align = "right" },
                        { "git_status",    zindex = 10, align = "right" },
                        { "file_size",     zindex = 10, align = "right" },
                        { "type",          zindex = 10, align = "right" },
                        { "last_modified", zindex = 10, align = "right" },
                        { "created",       zindex = 10, align = "right" },
                    },
                },
                { function() return { text = "gap", highlight = "Normal" } end }
            },
            message = {
                { "indent", with_markers = false },
                { "name",   highlight = "NeoTreeMessage" },
            },
            terminal = {
                { "indent" },
                { "icon" },
                { "name" },
                { "bufnr" }
            }
        },
        window = {                    -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
            -- possible options. These can also be functions that return these options.
            position = "left",        -- left, right, top, bottom, float, current
            width = 22,               -- applies to left and right positions
            height = 15,              -- applies to top and bottom positions
            auto_expand_width = true, -- expand the window when file exceeds the window width. does not work with position = "float"
            popup = {                 -- settings that apply to float position only
                size = {
                    height = "80%",
                    width = "50%",
                },
                position = "50%",       -- 50% means center it
                title = function(state) -- format the text that appears at the top of a popup window
                    return "Neo-tree " .. state.name:gsub("^%l", string.upper)
                end,
                -- you can also specify border here, if you want a different setting from
                -- the global popup_border_style.
            },
            insert_as = "child", -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
            -- "child":   Insert nodes as children of the directory under cursor.
            -- "sibling": Insert nodes  as siblings of the directory under cursor.
            -- Mappings for tree window. See `:h neo-tree-mappings` for a list of built-in commands.
            -- You can also create your own commands by providing a function instead of a string.
            mapping_options = {
                noremap = true,
                nowait = true,
            },
            mappings = {
                ["<space>"] = {
                    "toggle_node",
                    nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
                },
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                -- ["<cr>"] = { "open", config = { expand_nested_files = true } }, -- expand nested file takes precedence
                ["<esc>"] = "cancel", -- close preview or floating neo-tree window
                ["P"] = {
                    "toggle_preview",
                    config = {
                        use_float = true,
                        use_image_nvim = false,
                        -- title = "Neo-tree Preview", -- You can define a custom title for the preview floating window.
                    }
                },
                ["<C-f>"] = { "scroll_preview", config = { direction = -10 } },
                ["<C-b>"] = { "scroll_preview", config = { direction = 10 } },
                ["l"] = "focus_preview",
                ["S"] = "open_split",
                -- ["S"] = "split_with_window_picker",
                ["s"] = "open_vsplit",
                -- ["sr"] = "open_rightbelow_vs",
                -- ["sl"] = "open_leftabove_vs",
                -- ["s"] = "vsplit_with_window_picker",
                ["t"] = "open_tabnew",
                -- ["<cr>"] = "open_drop",
                -- ["t"] = "open_tab_drop",
                ["w"] = "open_with_window_picker",
                ["C"] = "close_node",
                --["C"] = "close_all_subnodes",
                ["z"] = "close_all_nodes",
                --["Z"] = "expand_all_nodes",
                --["Z"] = "expand_all_subnodes",
                ["R"] = "refresh",
                ["a"] = {
                    "add",
                    -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                    config = {
                        show_path = "none", -- "none", "relative", "absolute"
                    }
                },
                ["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
                ["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
                ["e"] = "toggle_auto_expand_width",
                ["q"] = "close_window",
                ["<leader>e"] = "close_window",
                ["?"] = "show_help",
                ["<"] = "prev_source",
                [">"] = "next_source",
            },
        },
        filesystem = {
            window = {
                mappings = {
                    ["H"] = "toggle_hidden",
                    ["/"] = "fuzzy_finder",
                    ["D"] = "fuzzy_finder_directory",
                    --["/"] = "filter_as_you_type", -- this was the default until v1.28
                    ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
                    -- ["D"] = "fuzzy_sorter_directory",
                    ["f"] = "filter_on_submit",
                    ["<C-x>"] = "clear_filter",
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                    ["[g"] = "prev_git_modified",
                    ["]g"] = "next_git_modified",
                    ["i"] = "show_file_details", -- see `:h neo-tree-file-actions` for options to customize the window.
                    ["b"] = "rename_basename",
                    ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
                    ["oc"] = { "order_by_created", nowait = false },
                    ["od"] = { "order_by_diagnostics", nowait = false },
                    ["og"] = { "order_by_git_status", nowait = false },
                    ["om"] = { "order_by_modified", nowait = false },
                    ["on"] = { "order_by_name", nowait = false },
                    ["os"] = { "order_by_size", nowait = false },
                    ["ot"] = { "order_by_type", nowait = false },
                },
                fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
                    ["<down>"] = "move_cursor_down",
                    ["<C-n>"] = "move_cursor_down",
                    ["<up>"] = "move_cursor_up",
                    ["<C-p>"] = "move_cursor_up",
                    ["<esc>"] = "close"
                },
            },
            async_directory_scan = "auto", -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
            -- "always" means directory scans are always async.
            -- "never"  means directory scans are never async.
            scan_mode = "shallow",            -- "shallow": Don't scan into directories to detect possible empty directory a priori
            -- "deep": Scan into directories to detect empty or grouped empty directories a priori.
            bind_to_cwd = true,               -- true creates a 2-way binding between vim's cwd and neo-tree's root
            cwd_target = {
                sidebar = "tab",              -- sidebar is when position = left or right
                current =
                "window"                      -- current is when position = current
            },
            check_gitignore_in_search = true, -- check gitignore status for files/directories when searching
            -- setting this to false will speed up searches, but gitignored
            -- items won't be marked if they are visible.
            -- The renderer section provides the renderers that will be used to render the tree.
            --   The first level is the node type.
            --   For each node type, you can specify a list of components to render.
            --       Components are rendered in the order they are specified.
            --         The first field in each component is the name of the function to call.
            --         The rest of the fields are passed to the function as the "config" argument.
            filtered_items = {
                visible = false,                       -- when true, they will just be displayed differently than normal items
                force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
                show_hidden_count = false,             -- when true, the number of hidden items in each folder will be shown as the last entry
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_hidden = false, -- only works on Windows for hidden files/directories
                hide_by_name = {
                    ".DS_Store",
                    "thumbs.db"
                    --"node_modules",
                },
                hide_by_pattern = { -- uses glob style patterns
                    --"*.meta",
                    --"*/src/*/tsconfig.json"
                },
                always_show = { -- remains visible even if other settings would normally hide it
                    --".gitignored",
                },
                always_show_by_pattern = { -- uses glob style patterns
                    --".env*",
                },
                never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                    --".DS_Store",
                    --"thumbs.db"
                },
                never_show_by_pattern = { -- uses glob style patterns
                    --".null-ls_*",
                },
            },
            find_by_full_path_words = false, -- `false` means it only searches the tail of a path.
            -- `true` will change the filter into a full path
            -- search with space as an implicit ".*", so
            -- `fi init`
            -- will match: `./sources/filesystem/init.lua
            --find_command = "fd", -- this is determined automatically, you probably don't need to set it
            --find_args = {  -- you can specify extra args to pass to the find command.
            --  fd = {
            --  "--exclude", ".git",
            --  "--exclude",  "node_modules"
            --  }
            --},
            ---- or use a function instead of list of strings
            --find_args = function(cmd, path, search_term, args)
            --  if cmd ~= "fd" then
            --    return args
            --  end
            --  --maybe you want to force the filter to always include hidden files:
            --  table.insert(args, "--hidden")
            --  -- but no one ever wants to see .git files
            --  table.insert(args, "--exclude")
            --  table.insert(args, ".git")
            --  -- or node_modules
            --  table.insert(args, "--exclude")
            --  table.insert(args, "node_modules")
            --  --here is where it pays to use the function, you can exclude more for
            --  --short search terms, or vary based on the directory
            --  if string.len(search_term) < 4 and path == "/home/cseickel" then
            --    table.insert(args, "--exclude")
            --    table.insert(args, "Library")
            --  end
            --  return args
            --end,
            group_empty_dirs = true,                -- when true, empty folders will be grouped together
            search_limit = 50,                      -- max number of search results when using filters
            follow_current_file = {
                enabled = false,                    -- This will find and focus the file in the active buffer every time
                --               -- the current file is changed while the tree is open.
                leave_dirs_open = false,            -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
            },
            hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
            -- in whatever position is specified in window.position
            -- "open_current",-- netrw disabled, opening a directory opens within the
            -- window like netrw would, regardless of window.position
            -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
            use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
            -- instead of relying on nvim autocmd events.
        },
    }
})
