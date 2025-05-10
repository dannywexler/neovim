
---@param ... table The tables to merge
---@return table
function MERGE(...)
    local res = {}
    local n = select("#", ...)
    for i = 1, n do
        local item = select(i, ...)
        if type(item) == "table" then
            res = vim.tbl_extend("force", res, item)
        end
    end
    return res
end
