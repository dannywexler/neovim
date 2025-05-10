---@param ... nil | boolean | number | string | table The items to print
function LOG(...)
    local n = select("#", ...)
    local res = { ... }
    for i = 1, n do
        local item = res[i]
        res[i] = type(item) == "string" and item or vim.inspect(item)
    end
    print(unpack(res))
end
