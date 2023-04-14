local api = vim.api
local aucmd = api.nvim_create_autocmd
local myColorGroup = api.nvim_create_augroup('MyColorGroup', { clear = true })

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
        api.nvim_set_hl(0, 'IndentBlanklineContextStart', {sp = '#1abc9c', underline = true})
        api.nvim_set_hl(0, 'IndentBlanklineContextSpaceChar', {sp = '#1abc9c', underline = true})
        -- setHL('@parameter', '#C408C4')
        -- setHL('UfoFoldedBg', '', '#240824')
        -- setHL('@variable.builtin', '#1dab2e')
        setHL('CmpItemAbbr', '#ffffff')
        -- setHL('Comment', '#b8bdd1')
        setHL('CursorLineNr', '#000000', '#00ffcc')
        setHL('FloatBorder', '#ffffff')
        setHL('IndentBlanklineIndent1', '#EEF06D')
        setHL('IndentBlanklineIndent2', '#7aa2f7')
        setHL('IndentBlanklineIndent3', '#5f43e9')
        setHL('IndentBlanklineIndent4', '#2ac3de')
        setHL('IndentBlanklineIndent5', '#e0af68')
        setHL('IndentBlanklineIndent6', '#c678dd')
        setHL('IndentBlanklineContextChar', "#1abc9c")
        setHL('IndentBlanklineContextSpaceChar', "#1abc9c")
        setHL('LeapBackdrop', '#b8bdd1')
        setHL('LeapLabelPrimary', '#00fa9a', '#000000')
        setHL('LeapLabelSecondary', '#1a1b26', '#7aa2f7')
        setHL('lualine_a_insert', '#000000', '#1abc9c')
        setHL('lualine_a_normal', '#000000', '#7aa2f7')
        setHL('lualine_a_visual', '#000000', '#c678dd')
        setHL('lualine_c_normal', '#ffffff', '#1f2335')
        -- setHL('MoreMsg', '#e535ab')
        -- setHL('Normal', '#ffffff', '#12131b')
        -- setHL('NormalNC', '#ffffff', '#171822')
        -- setHL('NormalFloat', '#ffffff')
        setHL('Pmenu', '#ffffff')
        setHL('PmenuSel', '#ffffff', '#004fc7')
        setHL('rainbowcol1', '#7aa2f7')
        setHL('rainbowcol2', '#bb9af7')
        setHL('rainbowcol3', '#35d27f')
        setHL('rainbowcol4', '#2ac3de')
        setHL('rainbowcol5', '#e0af68')
        setHL('rainbowcol6', '#7aa2f7')
        setHL('rainbowcol7', '#bb9af7')
        setHL('rainbowcol8', '#35d27f')
        setHL('rainbowcol9', '#2ac3de')
        setHL('rainbowcol10', '#e0af68')
        -- setHL('String', '#00fa9a')
        -- setHL('ToggleTerm1WinBar', '#000000', '#00ffcc')
        --#region
        setHL('UFOCustom', '#dd9afc')
        setHL('WinBar', '#000000', '#00ffcc')
        setHL('WinBarNC', '#000000', '#7aa2f7')
        -- setHL('WinSeparator', '#7aa2f7', '#000000')
        setHL('WinSeparator', '#7aa2f7')
        -- --
        linkHL('CmpItemAbbr', 'TelescopeNormal')
        linkHL('Comment', 'CmpItemMenu')
        linkHL('Comment', 'LineNr')
        linkHL('FloatBorder', 'TelescopeBorder')
        linkHL('Normal', 'NvimTreeIndentMarker')
        -- linkHL('Normal', 'NvimTreeNormal')
        -- linkHL('Normal', 'NvimTreeNormalNC')
        -- linkHL('Normal', '@variable')
        -- linkHL('String', 'Character')
        -- linkHL('WinBar', 'NavicText')
        -- linkHL('WinBar', 'ToggleTerm1WinBar')
    end
})

local niceColors = {
    blue = {
        '#004fc7',
        '#0061fe',
        '#0091f8',
        '#0944a1',
        '#0b0f7d',
        '#0c58d3',
        '#0d5ddf',
        '#0e65f0',
        '#3178c6',
        '#446ccf',
        '#4b78e6',
        '#61afef',
        '#7aa2f7',
    },
    green = {
        '#00fa9a',
        '#0e9e5a',
        '#1abc9c',
        '#35d27f',
        '#41b883',
        '#8ed891',
        '#4eefa2',
    },
    orange = {
        '#ef9062',
        '#e17b38',
        '#f14c28',
    },
    purple = {
        '#5f43e9',
        '#6366f1',
        '#8d6bd9',
        '#8997f5',
        '#c678dd',
    },
    pinkple = {
        '#b93998',
        '#c408c4',
        '#e535ab',
        '#d95398',
        '#eb75d6',
        '#f55385',
        '#ff007c',
    },
    teal = {
        '#00ffcc',
        '#2ac3de',
        '#3ac6be',
        '#77d3d1',
    },
    yellow = {
        '#EEF06D'
    }
}

-- local maxLines = 1000
-- aucmd({'InsertEnter',}, {
--     group = myColorGroup,
--     pattern = '*.js',
--     callback = function ()
--         if vim.api.nvim_buf_line_count(0) > maxLines then
--             -- print('toggling highlight')
--             vim.cmd('TSBufDisable highlight')
--         end
--     end
-- })
--
-- aucmd({'CursorHold'}, {
--     group = myColorGroup,
--     pattern = '*.js',
--     callback = function ()
--         if vim.api.nvim_buf_line_count(0) > maxLines then
--             -- print('toggling highlight')
--             vim.cmd('TSBufEnable highlight')
--         end
--     end
-- })

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
