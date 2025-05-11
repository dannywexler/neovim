local c = require("my.colors")

---@class HighlightConfig
---@field fg? string
---@field bg? string
---@field bold? boolean
---@field italic? boolean
---@field links? string[]


---Set highlights
---@param config table<string, HighlightConfig>
local function set_highlights(config)
    for hl_name, hl_value in pairs(config) do
        local opts = {}
        opts.fg = hl_value.fg or "NONE"
        opts.bg = hl_value.bg or "NONE"
        opts.bold = hl_value.bold
        opts.italic = hl_value.italic
        -- LOG("setting highlight:", hl_name, opts)
        vim.api.nvim_set_hl(0, hl_name, opts)
        for _, dest in ipairs(hl_value.links or {}) do
            -- LOG("linking highlight", hl_name, "to", dest)
            vim.api.nvim_set_hl(0, dest, { link = hl_name })
        end
    end
end

local hl_overrides = {
    CursorLine = { bg = c.grey.dim },
    SnacksInputBorder = { fg = c.green.dark },
    SnacksInputTitle = { fg = c.green.dark },
    Visual = { fg = c.white, bg = c.blue.dark },
    WinBar = { fg = c.black, bg = c.green.light },
    WinBarNC = { fg = c.black, bg = c.blue.light },
    WinSeparator = { fg = c.blue.light },
}

set_highlights(hl_overrides)
