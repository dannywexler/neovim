local api = vim.api
local aucmd = api.nvim_create_autocmd
local myColorGroup = api.nvim_create_augroup('MyGroup', { clear = true })

local function setHL(name, foreground, background, extraOpts)
    local opts = {}
    if foreground then opts.fg = foreground end
    if background then opts.bg = background end
    api.nvim_set_hl(0, name, opts)
end

local function linkHL(sourceName, destName)
    api.nvim_set_hl(0, destName, { link = sourceName })
end

aucmd('ColorScheme', {
    group = myColorGroup,
    callback = function()

        -- setHL('@parameter', '#C408C4')
        -- setHL('UfoFoldedBg', '', '#240824')
        setHL('@variable.builtin', '#1dab2e')
        setHL('CmpItemAbbr', '#ffffff')
        setHL('Comment', '#b8bdd1')
        setHL('CursorLineNr', '#000000', '#00ffcc')
        setHL('FloatBorder', '#ffffff')
        setHL('IndentBlanklineIndent1', '#E5C07B')
        setHL('IndentBlanklineIndent2', '#98C379')
        setHL('IndentBlanklineIndent3', '#61AFEF')
        setHL('IndentBlanklineIndent4', '#C678DD')
        setHL('LeapBackdrop', '#b8bdd1')
        setHL('LeapLabelPrimary', '#00fa9a', '#000000')
        setHL('LeapLabelSecondary', '#1a1b26', '#7aa2f7')
        setHL('lualine_a_insert', '#000000', '#1abc9c')
        setHL('lualine_a_normal', '#000000', '#7aa2f7')
        setHL('lualine_a_visual', '#000000', '#c678dd')
        setHL('lualine_c_normal', '#ffffff', '#1f2335')
        setHL('MoreMsg', '#e535ab')
        setHL('Normal', '#ffffff', '#12131b')
        setHL('NormalNC', '#ffffff', '#171822')
        setHL('Pmenu', '#ffffff')
        setHL('PmenuSel', '#ffffff', '#004fc7')
        setHL('rainbowcol1', '#c0caf5')
        setHL('rainbowcol10', '#f3d400')
        setHL('rainbowcol11', '#89e051')
        setHL('rainbowcol2', '#bb9af7')
        setHL('rainbowcol3', '#e0af68')
        setHL('rainbowcol4', '#9ece6a')
        setHL('rainbowcol5', '#8094b4')
        setHL('rainbowcol6', '#a074c4')
        setHL('rainbowcol7', '#e4b854')
        setHL('rainbowcol8', '#8dc149')
        setHL('rainbowcol9', '#e37933')
        setHL('String', '#00fa9a')
        setHL('ToggleTerm1WinBar', '#000000', '#00ffcc')
        setHL('UFOCustom', '#dd9afc')
        setHL('WinBar', '#000000', '#00ffcc')
        setHL('WinBarNC', '#000000', '#7aa2f7')
        setHL('WinSeparator', '#7aa2f7', '#000000')

        linkHL('CmpItemAbbr', 'TelescopeNormal')
        linkHL('Comment', 'CmpItemMenu')
        linkHL('Comment', 'LineNr')
        linkHL('FloatBorder', 'TelescopeBorder')
        linkHL('Normal', 'NvimTreeIndentMarker')
        linkHL('Normal', 'NvimTreeNormal')
        linkHL('Normal', 'NvimTreeNormalNC')
        linkHL('String', 'Character')
        linkHL('WinBar', 'NavicText')
        linkHL('WinBar', 'ToggleTerm1WinBar')
    end
})

local niceColors = {
    blue = {
        '#7aa2f7',
        '#61afef',
        '#0091f8',
        '#0e65f0',
        '#0d5ddf',
        '#0c58d3',
        '#0061fe',
        '#004fc7',
        '#0944a1',
    },
    green = {
        '#00fa9a',
        '#1abc9c',
        '#35d27f'
    },
    orange = {
        '#f14c28',
        '#ef9062'
    },
    purple = {
        '#5f43e9',
        '#c678dd',
        '#8997f5'
    },
    pinkple = {
        '#f55385',
        '#ff007c',
        '#e535ab',
        '#c408c4',
        '#b93998',
        '#eb75d6'
    },
    teal = {
        '#3ac6be',
        '#00ffcc',
        '#2ac3de'
    },
    yellow = {
        '#EEF06D'
    }
}

local maxLines = 1000
aucmd({'InsertEnter',}, {
    group = myColorGroup,
    pattern = '*.js',
    callback = function ()
        if vim.api.nvim_buf_line_count(0) > maxLines then
            -- print('toggling highlight')
            vim.cmd('TSBufDisable highlight')
        end
    end
})

aucmd({'CursorHold'}, {
    group = myColorGroup,
    pattern = '*.js',
    callback = function ()
        if vim.api.nvim_buf_line_count(0) > maxLines then
            -- print('toggling highlight')
            vim.cmd('TSBufEnable highlight')
        end
    end
})

--[[
-- Could just overwrite individual styles within tokyonight config
-- Or could copy and paste the source from here
-- https://github.com/folke/tokyonight.nvim/blob/main/extras/lua/tokyonight_night.lua
-- and modify it directly
-- Or at least use it as a base to get the raw list of highlight names
-- Could have a setFG(color, table of highlight names), and similar setBG
-- or could have one big Foregrounds = {
--      highlightName = colorName
-- }
-- and also matching Backgrounds = {
--      highlightName = colorName
-- }
--]]
