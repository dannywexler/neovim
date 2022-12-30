local lualine = require 'lualine'
local fn = vim.fn

local function customFileName(input)
    if vim.bo.filetype == 'NvimTree' then
        return fn.fnamemodify(fn.getcwd(), ':~:s?$?')
    elseif input:find('#toggleterm#') then
        local halfWidth = (vim.o.columns - 7) / 2
        return string.rep(' ', halfWidth) .. 'TERMINAL' .. string.rep(' ', halfWidth)
    else
        return fn.fnamemodify(fn.expand('%'), ':t')
    end
end

local function customFilePath(input)
    local specialNames = { 'Diffview', 'NvimTree', '#toggleterm#' }
    for _, specialName in ipairs(specialNames) do
        if input:find(specialName) then
            return ''
        end
    end
    return input
end

local function getFolder()
    return fn.fnamemodify(fn.getcwd(), ':t')
end

local buildStatusColors = {
    in_progress = '#ef9062',
    finished = '#1abc9c',
    error = '#f55385',
}

-- local spinners = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
-- local spinners = { '.     ', '..    ', '...   ', ' ...  ', '  ... ', '   ...', '    ..', '     .', '      ' }
local spinners = {
    '•     ',
    '••    ',
    '•••   ',
    ' •••  ',
    '  ••• ',
    '   •••',
    '    ••',
    '     •',
    '      ',
}

local function buildStatus()
    if fn.getcwd():find('danny') == nil then return '' end
    if Building == 'finished' then
        return 'Build finished'
    elseif Building == 'in_progress' then
        return 'Building ' .. spinners[os.date('%S') % #spinners + 1]
    elseif Building == 'error' then
        return 'Build error'
    else
        return ''
    end
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
                fmt = customFilePath,
                path = 1,
                shorting_target = 10
            },
            'diagnostics'
        },
        lualine_x = {
            -- 'aerial'
            {
                buildStatus,
                color = function () return { fg = buildStatusColors[Building] } end
            },
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
                'filename',
                fmt = customFileName,
                color = 'WinBar',
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
                'filename',
                fmt = customFileName,
                color = 'WinBarNC',
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
