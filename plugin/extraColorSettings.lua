local api = vim.api
local aucmd = api.nvim_create_autocmd
local myGroup = api.nvim_create_augroup('MyGroup', { clear = true })

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
    group = myGroup,
    callback = function()
        setHL('String', '#00fa9a')
        linkHL('String', 'Character')
    end
})
