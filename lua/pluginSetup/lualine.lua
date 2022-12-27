local lualine = require 'lualine'
local fn = vim.fn

local function customFileName()
    if vim.bo.filetype == 'NvimTree' then
        return fn.fnamemodify(fn.getcwd(), ':~:s?$?')
    else
        return fn.fnamemodify(fn.expand('%'), ':t')
    end
end

local function getFolder()
    return fn.fnamemodify(fn.getcwd(), ':t')
end

lualine.setup {
    extensions = {
        'aerial'
    },
    options = {
        component_separators = { left = '', right = '' },
        -- disabled_filetypes = {
        --     statusline = { 'NvimTree' },
        --     winbar = { 'NvimTree' },
        -- },
        globalstatus = false,
        icons_enabled = true,
        -- ignore_focus = { 'NvimTree' },
        section_separators = { left = '', right = '' },
        theme = 'auto',
    },
    sections = {
        lualine_a = { getFolder },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
            {
                'filename',
                fmt = function(input)
                    if input == 'NvimTree_1 [-]' then
                        return ''
                    end
                    return input
                end,
                path = 1,
                shorting_target = 10
            },
            'diagnostics'
        },
        lualine_x = {
            -- 'aerial'
        },
        lualine_y = {},
        -- lualine_z = {'location'}
        -- lualine_z = { '%3.3c%5.5l/%5.5L' }
        lualine_z = { [['%3.l/%L | %3.3c']] }
    },
    inactive_sections = {
        lualine_a = { getFolder },
        lualine_b = { 'branch' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    winbar = {
        lualine_a = {
            {
                customFileName,
                padding = 0
            }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_winbar = {
        lualine_a = {
            {
                customFileName,
                padding = 0
            }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    }
}
