-- local telescope = require'telescope'
local telescope = require 'telescope'
local actions = require 'telescope.actions'

local fullWindowWidth = vim.fn.winwidth(0)
local preferredWidth = 180

local custom_width = math.min(fullWindowWidth - 4, preferredWidth)

local custom_center_picker = {
    borderchars = {
        { '─', '│', '─', '│', '╭', '╮', '┘', '└' },
        prompt = { "─", "│", " ", "│", '╭', '╮', "│", "│" },
        results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
        preview = { '─', '│', '─', '│', '┌', '┐', "╯", "╰" },
    },
    layout_strategy = 'center',
    path_display = function(opts, path)
        local file = require("telescope.utils").path_tail(path)
        if file == path then
            return ' ' .. file
        else
            local endIndex = #file * -1
            endIndex = endIndex - 2
            local parentPath = path:sub(0, endIndex)
            local remainder = custom_width - #file - #parentPath - 10
            parentPath = (" "):rep(remainder) .. parentPath
            return string.format(" %s %s", file, parentPath)
        end
    end,
    previewer = false,
    prompt_title = false,
    results_title = false,
}

telescope.setup {
    defaults = {
        cache_picker = {
            num_pickers = -1,
            limit_entries = 5000,
        },
        entry_prefix = "  ",
        file_ignore_patterns = {
            -- ".git",
            -- ".doc",
            "node_modules",
            "/dist",
            "packer-compiled",
            ".pdf",
            ".sql",
            "target",
            "min.js"
        },
        layout_strategy = 'horizontal',
        layout_config = {
            center = {
                prompt_position = 'top',
                width = custom_width,
                height = 40,
            },
            horizontal = {
                prompt_position = 'top',
                width = 0.98,
                height = 0.97
            },
            vertical = {
                -- height = 0.98,
                width = custom_width,
                height = 20,
                prompt_position = 'top'
            }
        },
        mappings = {
            i = {
                ["<ESC>"] = actions.close,
                ["jk"] = actions.close,
            }
        },
        path_display = function(opts, path)
            print(path, " -> recieved opts", opts)
            return path
        end,
        prompt_prefix = "    ",
        sorting_strategy = 'ascending',
        selection_caret = "  ",
    },
    pickers = {
        buffers = {
            ignore_current_buffer = true,
            only_cwd = true,
            sort_mru = true,
        },
        find_files = custom_center_picker,
        grep_string = {
            path_display = { 'tail' },
            show_line = true,
        },
        live_grep = {
            path_display = { 'tail' },
            show_line = true,
        },
        lsp_document_symbols = {
            show_line = true,
            -- symbols = 'function'
        },
        lsp_references = {
            path_display = { 'tail' },
            show_line = true,
        },
        smart_open = custom_center_picker,
    },
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case"
            -- case_mode = "respect_case"
        },
        smart_open = {
            show_scores = false,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
            match_algorithm = "fzf",
            disable_devicons = false,
        },
    },
}

if WINDOWS then
    vim.g.sqlite_clib_path = "C:/bit9prog/dev/SQLite/sqlite3.dll"
end
-- telescope.load_extension('zf-native')
-- telescope.load_extension('smart_open')
telescope.load_extension('fzf')
