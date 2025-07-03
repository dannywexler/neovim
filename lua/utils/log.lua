local scope_width = 14
local arrow = " --> "
local log_buf = -1
local log_win = nil

local function ensure()
    if log_buf < 0 then
        log_buf = vim.api.nvim_create_buf(false, true)
        print("log.ensure.initialize_buf", log_buf)
    end
    if not log_win then
        print("log.ensure.initialize_win")
        log_win = require("snacks").win.new({
            buf = log_buf,
            backdrop = false,
            border = vim.o.winborder,
            height = 0.99,
            position = "float",
            show = false,
            width = 0,
        })
    end

    log_win:set_title("Log Messages", "left")
    return log_buf, log_win
end

---@param scope string
---@param text string
local function append(scope, text)
    local buf = ensure()
    local lines = vim.iter(ipairs(vim.split(text, "\n")))
        :map(function(index, item)
            if index == 1 then
                return scope .. item
            end
            return (" "):rep(#scope) .. item
        end)
        :totable()
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
end

local function toggle()
    local _, win = ensure()
    win:toggle()
end

---@param item any
---@return string
local function format_item(item)
    if type(item) == "nil" then return "NIL" end
    if type(item) ~= "string" then
        return vim.inspect(item)
    end
    if #item == 0 then return "EMPTY_STRING" end
    return item
end

---@param scope string
---@param ... nil | boolean | number | string | table The items to print
local function log_items(scope, ...)
    local total = select("#", ...)
    local res = ""
    local first_item = true
    for i = 1, total do
        local item = select(i, ...)
        local prefix = " "
        if first_item then
            first_item = false
            prefix = ""
        end
        res = res .. prefix .. format_item(item)
    end
    append(scope, res)
end

---@param module string
local function create_logger(module)
    local padding = (" "):rep(scope_width - #module)
    local padded_module = module .. padding .. arrow
    ---@param function_name string
    return function(function_name)
        local func = function_name .. arrow
        ---@param ... nil | boolean | number | string | table The items to print
        return function(...)
            local scope = padded_module .. func
            log_items(scope, ...)
        end
    end
end

return {
    create_logger = create_logger,
    toggle = toggle,
}
