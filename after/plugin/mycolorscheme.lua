local c = require("my.colors")

---@class HighlightConfig
---@field fg? string
---@field bg? string
---@field bold? boolean
---@field italic? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field sp? string
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
        opts.underline = hl_value.underline
        opts.undercurl = hl_value.undercurl
        opts.sp = hl_value.sp
        -- LOG("setting highlight:", hl_name, opts)
        vim.api.nvim_set_hl(0, hl_name, opts)
        for _, dest in ipairs(hl_value.links or {}) do
            vim.api.nvim_set_hl(0, dest, { link = hl_name })
        end
    end
end

---@type table<string, HighlightConfig>
local hl_overrides = {
    CursorLine = { bg = c.greyDim },
    DiagnosticUnderlineError = { fg = c.red, sp = c.red, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.purple, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.orange, undercurl = true },
    DiagnosticUnderlineWarn = { fg = c.yellow, sp = c.yellow, undercurl = true },
    Identifier = { fg = c.greenDark },
    SleekErrorsError = { fg = c.black, bg = c.red, bold = true },
    SleekErrorsHint = { fg = c.black, bg = c.purple, bold = true },
    SleekErrorsInfo = { fg = c.black, bg = c.orange, bold = true },
    SleekErrorsWarn = { fg = c.black, bg = c.yellow, bold = true },
    SnacksInputBorder = { fg = c.greenDark },
    SnacksInputTitle = { fg = c.greenDark },
    Visual = { fg = c.white, bg = c.blueDark },
    WinBar = { fg = c.black, bg = c.greenLight },
    WinBarNC = { fg = c.black, bg = c.blueLight },
    WinSeparator = { fg = c.blueLight },
    ["@keyword.return"] = { fg = c.purple },
    ["@variable.member"] = { fg = c.greenDark },
    ["@variable.parameter"] = { fg = c.pink },
}

set_highlights(hl_overrides)
