
---@param ... table The tables to merge
---@return table
function MERGE(...)
    local res = {}
    for _, item in ipairs({...}) do
        if type(item) == "table" then
            res = vim.tbl_extend("force", res, item)
        end
    end
    return res
end
