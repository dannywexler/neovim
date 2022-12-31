local lualine = require 'lualine'
local fn = vim.fn

local function isTerm()
    return vim.bo.filetype == 'toggleterm'
end

local function notTerm()
    return vim.bo.filetype ~= 'toggleterm'
end

local function customFileName(input)
    local filetype = vim.bo.filetype
    if filetype == 'NvimTree' then
        return fn.fnamemodify(fn.getcwd(), ':~:s?$?')
    else
        return fn.fnamemodify(fn.expand('%'), ':t')
    end
end

local function customFilePath(input)
    local ignoreNames = { 'Diffview', 'NvimTree'}
    for _, ignoreName in ipairs(ignoreNames) do
        if input:find(ignoreName) then
            return ''
        end
    end

    if isTerm() then return '  TERMINAL' end

    return input
end

local function getFolder()
    return fn.fnamemodify(fn.getcwd(), ':t')
end

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
    if not WINDOWS or fn.getcwd():find('bit9prog') == nil then return '' end
    if BuildStatus == 'finished' then
        return 'Build finished'
    elseif BuildStatus == 'in_progress' then
        return 'Building ' .. spinners[os.date('%S') % #spinners + 1]
    else
        return BuildStatus
    end
end

local function buildStatusColor()
    local fgColor = '#f55385'

    if BuildStatus == 'finished' then
        fgColor = '#1abc9c'
    elseif BuildStatus == 'in_progress' then
        fgColor = '#ef9062'
    end

    return { fg = fgColor, bg = '#000000' }
end

lualine.setup {
    extensions = {
        'aerial'
    },
    options = {
        component_separators = { left = '', right = '' },
        -- disabled_filetypes = {
        --     statusline = { 'NvimTree' },
            -- winbar = { 'toggleterm' },
        -- },
        globalstatus = false,
        icons_enabled = true,
        -- ignore_focus = { 'NvimTree' },
        section_separators = { left = '', right = '' },
        theme = 'auto',
    },
    sections = {
        lualine_a = {
            getFolder,
            {
                buildStatus,
                color = buildStatusColor
            },
        },
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
        },
        lualine_y = {},
        -- lualine_z = {'location'}
        -- lualine_z = { '%3.3c%5.5l/%5.5L' }
        lualine_z = {
            {
                [['%3.l/%L | %3.3c']],
                cond = notTerm,
            },
        }
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
                cond = notTerm,
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
