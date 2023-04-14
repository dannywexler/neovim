local lualine = require 'lualine'
local navic = require 'nvim-navic'
-- local noice = require("noice").api.status
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
    elseif filetype == 'aerial' then
        return 'OUTLINE'
    else
        return fn.fnamemodify(fn.expand('%'), ':t')
    end
end

local function customFilePath(input)
    local ignoreNames = { 'Diffview', 'NvimTree' }
    for _, ignoreName in ipairs(ignoreNames) do
        if input:find(ignoreName) then
            return ''
        end
    end

    if isTerm() then return '  TERMINAL' end

    return input
end

local function getFolder()
    -- return fn.fnamemodify(fn.getcwd(), ':t')
    return fn.getcwd()
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
    -- extensions = {
    --     'aerial'
    -- },
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
    refresh = {
        -- statusline = 500,
        statusline = 100,
        -- winbar = 500
        winbar = 100
    },
    sections = {
        lualine_a = {
            getFolder,
            {
                buildStatus,
                color = buildStatusColor
            },
        },
        -- lualine_b = { 'branch', 'diff' },
        lualine_b = {},
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
            -- {
            --     noice.message.get_hl,
            --     cond = noice.message.has
            -- }
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
        -- lualine_a = { getFolder },
        lualine_a = { },
        -- lualine_b = { 'branch' },
        lualine_b = { },
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
                padding = 1
            },
            {
                -- function ()
                --     local location = navic.get_location()
                --     local locationLength = location:len()
                --     if locationLength == 0 then return '' end
                --
                --     local filenameLength = vim.fn.expand('%:t'):len() + 4
                --     -- print('filenameLength: ' .. tostring(filenameLength))
                --     local availableSpace = vim.api.nvim_win_get_width(0) - filenameLength
                --     -- print('availableSpace: ' .. tostring(availableSpace))
                --     local gap = availableSpace - locationLength
                --     print('gap: ' .. tostring(gap))
                --     local trimmedLocation = location
                --     if gap >= 0 then
                --         trimmedLocation = string.rep(' ', gap) .. location
                --     else
                --         trimmedLocation = location:sub(1,availableSpace)
                --     end
                --
                --     -- return '   ' .. trimmedLocation
                --     return trimmedLocation
                -- end,
                -- function ()
                --     local location = navic.get_location()
                --     if location:len() == 0 then return '' end
                --
                --     return '   ' .. location
                -- end,
                function ()
                    local location = navic.get_location()
                    if location:len() == 0 then return '' end

                    local filenameLength = vim.fn.expand('%:t'):len() + 4
                    local availableSpace = vim.api.nvim_win_get_width(0) - filenameLength
                    local trimmedLocation = location:sub(1,math.min(location:len(), availableSpace + 20))
                    return '   ' .. trimmedLocation
                end,
                -- navic.get_location,
                cond = navic.is_available,
                color = 'WinBar'
            }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
        },
        lualine_y = {},
        lualine_z = {
            -- {
            --     navic.get_location,
            --     cond = navic.is_available,
            --     color = 'WinBar'
            -- }
        }
    },
    inactive_winbar = {
        lualine_a = {
            {
                'filename',
                fmt = customFileName,
                color = 'WinBarNC',
                cond = notTerm,
                padding = 1
            }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    }
}
