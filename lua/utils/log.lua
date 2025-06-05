local function format_item(item)
    if type(item) == "nil" then return "NIL" end
    if type(item) ~= "string" then
        return vim.inspect(item)
    end
    if #item == 0 then return "EMPTY_STRING" end
    return item
end

---@param ... nil | boolean | number | string | table The items to print
function LOG(...)
    local n = select("#", ...)
    local res = { ... }
    for i = 1, n do
        res[i] = format_item(res[i])
    end
    print(unpack(res))
end
