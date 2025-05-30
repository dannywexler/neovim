local cmd = function(aCommand)
    return ("<cmd>%s<cr>"):format(aCommand)
end

local helpers = {
    normal = {
        line = {
            shift = {
                down = ":m .+1<CR>==",
                j = ":m .+1<CR>==",
                left = "V<<Esc>",
                h = "V<<Esc>",
                right = "V><Esc>",
                l = "V><Esc>",
                up = ":m .-2<CR>==",
                k = ":m .-2<CR>==",
            }
        },
    },
    visual = {
        line = {
            shift = {
                down = ":m '>+1<CR>gv=gv",
                j = ":m '>+1<CR>gv=gv",
                left = "<gv",
                h = "<gv",
                right = "V><Esc>",
                l = "V><Esc>",
                up = ":m '<-2<CR>gv=gv",
                k = ":m '<-2<CR>gv=gv",
            }
        },
    },
    win = {
        split = {
            vertical = cmd("vsplit"),
            horizontal = cmd("split"),
        }
    }
}

---@class sleekeymap.Node
---@field [string] sleekeymap.Node | string | function


---@param table1 (string | number)[]
---@param itemOrTable table | string
local function concat(table1, itemOrTable)
    local result = {}
    for _, value in ipairs(table1) do
        table.insert(result, value)
    end
    if type(itemOrTable) == "table" then
        for _, secondValue in ipairs(itemOrTable) do
            table.insert(result, secondValue)
        end
    else
        table.insert(result, itemOrTable)
    end
    return result
end


local modifiers = {
    "ctrl",
    "control",
    "alt",
    "shift",
}

local function set_keymap(mode, lhs, rhs)
    -- LOG("=== set_keymap === START =============")
    -- LOG("mode:", mode, "lhs:", lhs, "rhs:", rhs)
    -- LOG("=== set_keymap ===  END  =============")
    vim.keymap.set(mode, lhs, rhs, {
        silent = true,
        noremap = true,
    })
end


local function format_keymap(lhsTable, rhs)
    -- LOG("=== format_keymap === START ==========")
    -- LOG("FINAL lhsTable", lhsTable, "rhs:", rhs)
    local mode = lhsTable[1]
    local lhs = ""
    local index = 2
    while index <= #lhsTable do
        local currentItem = lhsTable[index]
        local nextItem = lhsTable[index + 1]
        -- LOG("currentItem:", currentItem, "nextItem:", nextItem)
        if #currentItem > 1 then
            if vim.tbl_contains(modifiers, currentItem) then
                currentItem = ("<%s-%s>"):format(currentItem:sub(1, 1), nextItem)
                index = index + 1
            else
                currentItem = "<" .. currentItem .. ">"
            end
        end
        lhs = lhs .. currentItem
        index = index + 1
    end
    -- LOG("index: ", index, "currentItem: ", currentItem)
    set_keymap(mode, lhs, rhs)
    -- LOG("=== format_keymap ===  END  ==========")
end


-- -@param mappings table<string, table<string, string|function> | string | function>
---@param mappings table<string, sleekeymap.Node>
---@param lhsTable string[]
local function parse_keymaps(mappings, lhsTable)
    for lhs, rhs in pairs(mappings) do
        local newLhsTable = concat(lhsTable, lhs)
        if type(rhs) == "table" then
            parse_keymaps(rhs, newLhsTable)
        elseif type(rhs) == "string" or type(rhs) == "function" then
            format_keymap(newLhsTable, rhs)
        end
    end
end

---Setup keymaps
-- -@param mappings table<string, table<string, string|function> | string | function>
---@param mappings table<string, sleekeymap.Node>
local function set(mappings)
    -- LOG("sleekeymap setting mappings:", mappings)
    parse_keymaps(mappings, {})
end

return {
    cmd = cmd,
    helpers = helpers,
    set = set,
}
