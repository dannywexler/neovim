local lualine = require 'lualine'
local navic = require 'nvim-navic'
-- local noice = require("noice").api.status
local fn = vim.fn
local custom_tokyo = require 'lualine.themes.tokyonight'
custom_tokyo.normal.c.bg = '#1f2335'

local fileTypeMap = {
    DiffviewFiles = 'DIFF',
    NvimTree = 'File Tree',
    TelescopePrompt = 'Telescope  ',
    toggleterm = 'TERMINAL  ',
}

local function isTerm()
    return vim.bo.filetype == 'toggleterm'
end

local function notTerm()
    return vim.bo.filetype ~= 'toggleterm'
end

local function regularFileType()
    local filetype = vim.bo.filetype
    for ft, _ in pairs(fileTypeMap) do
        if filetype == ft then return false end
    end
    return true
end

local function customFileName(input)
    local filetype = vim.bo.filetype
    if filetype == 'NvimTree' then
        return fn.fnamemodify(fn.getcwd(), ':~:s?$?')
    elseif filetype == 'aerial' then
        return 'OUTLINE'
    else
        -- return fn.fnamemodify(fn.expand('%'), ':t')
        return input
    end
end

local function customFilePath(input)
    local filetype = vim.bo.filetype


    for fType, name in pairs(fileTypeMap) do
        if filetype == fType then return name end
    end
    -- local ignoreNames = { 'Diffview', 'NvimTree', 'No Name'  }
    -- for _, ignoreName in ipairs(ignoreNames) do
    --     if input:find(ignoreName) or input:len() == 0 then
    --         return ' '
    --     end
    -- end

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

local fileStatusSymbols = {
    modified = '[MOD]',    -- Text to show when the file is modified.
    readonly = '[RO]',     -- Text to show when the file is non-modifiable or readonly.
    unnamed = '[No Name]', -- Text to show for unnamed buffers.
    newfile = '[New]',     -- Text to show for newly created file before first write
}

lualine.setup {
    -- extensions = {
    --     'aerial'
    -- },
    options = {
        --     statusline = { 'NvimTree' },
        -- disabled_filetypes = {
        -- ignore_focus = { 'NvimTree' },
        -- winbar = { 'toggleterm' },
        -- },
        component_separators = { left = '', right = '' },
        globalstatus = true,
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        theme = custom_tokyo,
    },
    refresh = {
        statusline = 500,
        -- statusline = 100,
        winbar = 500
        -- winbar = 100
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
                shorting_target = 10,
                symbols = fileStatusSymbols,
            },
            {
                'filetype',
                colored = true,
                icon_only = true,
                padding = { left = 0, right = 1 },
                cond = regularFileType
            },
            'diagnostics'
        },
        lualine_x = {
            -- 'aerial'
            -- {
            --     noice.message.get_hl,
            --     cond = noice.message.has
            -- }
            -- {
            --     'searchcount',
            --     fmt = function(search)
            --         if search:len() == 0 then return '' end
            --         return 'Search Result ' .. search
            --     end,
            -- },
        },
        lualine_y = {},
        -- lualine_z = {}
        -- lualine_z = {'location'}
        -- lualine_z = { '%3.3c%5.5l/%5.5L' }
        lualine_z = {
            {
                [['%3.l/%L | %3.3c']],
                cond = regularFileType,
            },
        }
    },
    inactive_sections = {
        -- lualine_a = { getFolder },
        lualine_a = {},
        -- lualine_b = { 'branch' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    winbar = {
        lualine_a = {
            {
                'filetype',
                colored = false,
                icon_only = true,
                color = 'WinBar',
                cond = regularFileType,
                padding = { left = 1 }
            },
            {
                'filename',
                fmt = customFileName,
                color = 'WinBar',
                cond = notTerm,
                symbols = fileStatusSymbols,
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
                function()
                    local location = navic.get_location()
                    if location:len() == 0 then return '' end

                    local filenameLength = vim.fn.expand('%:t'):len() + 4
                    local availableSpace = vim.api.nvim_win_get_width(0) - filenameLength
                    local trimmedLocation = location:sub(1, math.min(location:len(), availableSpace + 20))
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
                'filetype',
                colored = false,
                icon_only = true,
                color = 'WinBarNC',
                cond = regularFileType,
                padding = { left = 1 }
            },
            {
                'filename',
                fmt = customFileName,
                color = 'WinBarNC',
                cond = notTerm,
                symbols = fileStatusSymbols,
            }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    }
}
