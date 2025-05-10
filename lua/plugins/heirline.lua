local myColors = require("my.colors")

local fmodify = vim.fn.fnamemodify
local getcwd = vim.fn.getcwd
local expand = vim.fn.expand

local function normalize(sourceString)
    return fmodify(sourceString, ":gs?\\?/?")
end

---@class Highlight
---@field fg? string
---@field bg? string
---@field bold? boolean

---@class ComponentInfo
---@field current_bg string

---@alias Provider string | number | fun(info: ComponentInfo): string | number | nil

---@alias Side "left" | "right"

---@class Component
---@field condition? fun(info: ComponentInfo): boolean
---@field init? fun(info: ComponentInfo)
---@field provider? fun(info: ComponentInfo): string | number | nil
---@field hl? Highlight | string | fun(info: ComponentInfo): Highlight | string | nil  controls the colors of what is printed by the component's provider, or by any of its descendants.
---@field update? string | string[]
---@field static? table<string, string | function | table>
---@field [...] Component

local vim_mode_colors = {
    i = myColors.green.dark,
    n = myColors.purple,
    v = myColors.blue.medium,
    V = myColors.blue.medium,
}

local sl_bg = myColors.grey.medium

local wb_active_bg = myColors.green.light
local wb_other_bg = myColors.blue.light

local scrollbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }

---@param component Component
---@param count integer?
---@return Component
local function sb_gap(component, count)
    return {
        condition = component.provider,
        provider = function() return ("g"):rep(count or 1) end,
        hl = {
            fg = sl_bg,
            bg = sl_bg,
        }
    }
end

---@param component Component
---@param count integer?
---@return Component
local function wb_gap(component, count)
    return {
        condition = component.provider,
        provider = function() return ("g"):rep(count or 1) end,
        hl = function(info)
            return {
                fg = info.current_bg,
                bg = info.current_bg,
            }
        end
    }
end

---Create a Component
---@param component Component
---@return Component
local function comp(component)
    return MERGE({
        hl = function(info)
            return {
                fg = myColors.black,
                bg = info.current_bg,
            }
        end
    }, component)
end


return PLUG("rebelot/heirline.nvim", {
    opts = function()
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")

        ---Multiple components
        ---@param statusline_or_winbar "statusline" | "winbar"
        ---@param parent Component
        ---@param ... Component
        ---@return Component[]
        local function comps(statusline_or_winbar, parent, ...)
            local others = {}
            for _, cmp in ipairs({ ... }) do
                table.insert(others, comp(cmp))
                if (statusline_or_winbar == "statusline") then
                    table.insert(others, sb_gap(cmp))
                else
                    table.insert(others, wb_gap(cmp))
                end
            end
            return utils.insert(parent, others)
        end

        ---@param side Side
        ---@param component Component
        ---@return Component
        local function bubble_sep(side, component)
            return {
                condition = component.provider,
                provider = function() return side == "left" and "" or "" end,
                hl = function(info)
                    return {
                        fg = info.current_bg,
                        bg = sl_bg,
                    }
                end
            }
        end

        ---@param cmp Component
        ---@return ... Component
        local function bubble(cmp)
            return {
                bubble_sep("left", cmp),
                cmp,
                bubble_sep("right", cmp),
            }
        end

        local statusline_parent = {
            provider = " ",
            init = function(info)
                info.current_bg = vim_mode_colors[vim.fn.mode()] or myColors.orange
            end,
            hl = function()
                return {
                    bg = sl_bg,
                    fg = myColors.white,
                    bold = true,
                }
            end,
            update = {
                "ModeChanged"
            }
        }

        local statusline = comps(
            "statusline",
            statusline_parent,
            bubble(
                {
                    provider = function() return normalize(fmodify(getcwd(), ":~:h")) end,
                    update = { "ModeChanged", "VimEnter" },
                }
            ),
            bubble({
                provider = function() return normalize(fmodify(getcwd(), ":t")) end,
                update = { "ModeChanged", "VimEnter" },
            }),
            bubble({
                provider = function()
                    local relativePath = normalize(expand("%:.:h"))
                    if relativePath == "." then
                        -- LOG("RelativePath got . so returning nil")
                        return nil
                    end
                    -- LOG("RelativePath:", relativePath, "length:", #relativePath)
                    return relativePath
                end,
                update = { "ModeChanged", "BufEnter" },
            }),
            bubble({
                provider = function() return expand("%:t") end,
                update = { "ModeChanged", "BufEnter" }
            }),
            { provider = function() return "%=" end, hl = { fg = sl_bg, bg = sl_bg } },
            bubble({ provider = function() return vim.fn.mode() end })
        )

        -- WINBAR CONFIG BELOW HERE

        local winbar_parent = {
            provider = " ",
            init = function(info)
                info.current_bg = conditions.is_active() and wb_active_bg or wb_other_bg
            end,
            hl = function(info)
                return {
                    fg = myColors.black,
                    bg = info.current_bg,
                    bold = true
                }
            end
        }

        local winbar = comps(
            "winbar",
            winbar_parent,
            {
                provider = function() return expand("%:t") end,
                update = { "BufEnter" }
            },
            { provider = function() return "%=" end, },
            {
                provider = function()
                    local cursor = vim.api.nvim_win_get_cursor(0)
                    local currentLine = cursor[1]
                    local currentCol = cursor[2]
                    local totalLines = vim.api.nvim_buf_line_count(0)
                    local totalLinesWidth = #tostring(totalLines)
                    local index = math.floor((currentLine - 1) / totalLines * #scrollbar) + 1
                    local progress = (scrollbar[index]):rep(2)
                    return ("%s %" .. totalLinesWidth .. "s/%s | %3s "):format(progress, currentLine, totalLines, currentCol)
                end
            }
        )
        require("heirline").setup({
            statusline = statusline,
            winbar = winbar,
        })
    end
})
