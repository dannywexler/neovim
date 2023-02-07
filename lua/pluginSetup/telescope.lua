-- local telescope = require'telescope'
local telescope = require 'telescope'
local actions = require 'telescope.actions'

local fullWindowWidth = vim.fn.winwidth(0)
local preferredWidth = 140

local custom_width = math.min(fullWindowWidth - 4, preferredWidth)

telescope.setup {
    defaults = {
        entry_prefix = "  ",
        file_ignore_patterns = {
            -- ".git",
            -- ".doc",
            "node_modules",
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
        find_files = {
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
                    local fileLen = string.len(file)
                    local endIndex = fileLen * -1
                    endIndex = endIndex - 2
                    local parentPath = string.sub(path, 0, endIndex)
                    local remainder = custom_width - fileLen - string.len(parentPath) - 10
                    for i = 0, remainder, 1 do
                        parentPath = " " .. parentPath
                    end
                    return string.format(" %s %s", file, parentPath)
                end
            end,
            previewer = false,
            prompt_title = false,
            results_title = false,
        },
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
        }
    }
}

telescope.load_extension('zf-native')
