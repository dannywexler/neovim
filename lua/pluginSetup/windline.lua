local windline    = require('windline')
local builtin     = require('windline.components.basic')

local helper      = require('windline.helpers')
local sep         = helper.separators

local cache_utils = require('windline.cache_utils')

local state       = _G.WindLine.state
local fn          = vim.fn

local fileTypeMap = {
    DiffviewFiles = 'DIFF',
    -- NvimTree = 'File Tree',
    TelescopePrompt = ' Telescope  ',
    toggleterm = 'TERMINAL  ',
}

local myColors    = {
    darkGreen = '#1abc9c',
    blue = '#7aa2f7',
    darkGrey = '#1f2335',
    lightOrange = '#ef9062',
}

local hl_colors   = {
    NormalMode    = { 'black', 'blue_light' },
    InsertMode    = { 'black', 'green' },
    VisualMode    = { 'black', 'magenta' },
    ReplaceMode   = { 'black', 'cyan' },
    CommandMode   = { 'black', 'lightOrange' },
    MiddleSection = { 'white', 'darkGrey' }
}

local divider     = { builtin.divider, '' }
local space_bg    = { ' ', 'background' }

local function getFolder()
    return ' ' .. fn.fnamemodify(fn.getcwd(), ':~:s?$?') .. ' '
end

local function getHLMode()
    return state.mode[2] .. 'Mode'
end

local folder = {
    text = getFolder,
    hl_colors = hl_colors,
    hl = getHLMode
}

local function formatFileName(bufnr)
    local fileType = vim.bo.filetype
    local fileTypeMatch = fileTypeMap[fileType]
    if fileTypeMatch then return fileTypeMatch end

    local originalFileName = fn.bufname(bufnr)
    local cwd = fn.getcwd()
    local fileName = originalFileName:gsub(cwd .. '/', '')
    if fileName == 'NvimTree_1' then
        return getFolder()
    end
    return ' ' .. fileName .. ' '
end

local currentFileName = {
    text = function(bufnr)
        local storedFileName = vim.b[bufnr].wl_file_name
        if storedFileName == nil then
            storedFileName = formatFileName(bufnr)
            vim.b[bufnr].wl_file_name = storedFileName
        end
        return storedFileName
    end,
    hl = 'MiddleSection'
}

local lineAndCol = {
    text = function()
        return ' %3.l/%L | %3.3c '
    end,
    hl_colors = hl_colors,
    hl = getHLMode
}

local default = {
    filetypes = { 'default' },
    active = {
        folder,
        currentFileName,
        -- file_name,
        { builtin.cache_file_icon(), '' },
        divider,
        lineAndCol
    },
    inactive = {
        folder,
    },
}

local explorer = {
    filetypes = { 'NvimTree' },
    active = {
        folder,
        { ' NvimTree  ', 'MiddleSection' },
    },
    always_active = true
}

local toggleterm = {
    filetypes = { 'toggleterm' },
    active = {
        folder,
        { ' TERMINAL  ', 'MiddleSection' },
    },
    always_active = true
}

local winbar = {
    filetypes = { 'winbar' },
    active = {
        { ' ',                       '' },
        { builtin.cache_file_icon(), '' },
        currentFileName
    },
    inactive = {
        { ' ',                       '' },
        { builtin.cache_file_icon(), '' },
        currentFileName
    }
}

windline.setup {
    colors_name = function(colors)
        colors.blue_light = myColors.blue
        colors.green = myColors.darkGreen
        colors.darkGrey = myColors.darkGrey
        colors.lightOrange = myColors.lightOrange
        return colors
    end,
    statuslines = {
        default,
        explorer,
        toggleterm,
        winbar,
    }
}
