local M = {}

local modifiers = {
    alt = 'a',
    control = 'c',
    ctrl = 'c',
}

---Sets the formatted keymap
---@param mode string
---@param lhsString string
---@param rhs string
local function setKeymap(mode, lhsString, rhs)
    --P("SETTINGKEYMAP mode:", mode, "lhsString:", lhsString, "and rhs:", rhs)
    -- P('=================================================================')
    --P('')
    --P('')
    vim.keymap.set(mode, lhsString, rhs, {
        silent = true
    })
end

---Formats the mode, and lhs from table to string
---@param lhsTable string[]
---@param rhs string | function
local function formatKeymap(lhsTable, rhs)
    local mode = table.remove(lhsTable, 1)
    --P("FORMATKEYMAP mode:", mode, "lhs:", lhsTable, "and rhs:", rhs)
    local lhsString = ''
    local modsTable = {}
    local index = 1
    local item = lhsTable[index]
    while index <= #lhsTable do
        --P('got item:', item)
        if item == 'ldr' or item == 'leader' then
            lhsString = '<leader>'
        elseif #item > 1 then
            local mod = modifiers[lhsTable[index]] or item
            --P('got mod:', mod)
            if mod:match('%u') then
                --P('mod is uppercase')
                U.uadd(modsTable, 's')
            end
            table.insert(modsTable, mod)
            local nextItem = lhsTable[index + 1]
            if nextItem and #nextItem == 1 then
                table.insert(modsTable, nextItem)
                index = index + 1
                item = lhsTable[index]
            end
        else
            lhsString = lhsString .. item
        end
        index = index + 1
        item = lhsTable[index]
    end
    if #modsTable > 0 then
        local modsLHS = '<' .. table.concat(modsTable, '-') .. '>'
        lhsString = modsLHS .. lhsString
    end
    setKeymap(mode, lhsString, rhs)
end

---Recursively parses keymaps
---@param oldLHS string[]
---@param RHS table<string, table | string | function>
local function parseKeymaps(oldLHS, RHS)
    for key, value in vim.spairs(RHS) do
        local LHS = vim.deepcopy(oldLHS)
        table.insert(LHS, key)
        if V.isTable(value) then
            parseKeymaps(LHS, value)
        elseif V.isString(value) or V.isFunction(value) then
            formatKeymap(LHS, value)
        end
    end
end

---Recursively sets nested keymaps
---@param fullTable table<string, any>
M.set = function(fullTable)
    for key, value in pairs(fullTable) do
        parseKeymaps({ key }, value)
    end
end

---@param cmdString string
---@return string
M.cmd = function(cmdString)
    return '<cmd>' .. cmdString .. '<cr>'
end

return M
