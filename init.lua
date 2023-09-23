local api = vim.api
local myGroup = api.nvim_create_augroup('MyGroup', { clear = true })

P = function(...)
    local args = { ... }
    local res = {}
    for _, item in ipairs(args) do
        table.insert(res, vim.inspect(item))
    end
    print(unpack(res))
end

U = {}

U.LINUX = vim.fn.has("win32") == 0

U.aucmd = function(event, opts)
    local defaultOpts = { group = myGroup }
    local mergedOpts = U.merge(defaultOpts, opts)
    api.nvim_create_autocmd(event, mergedOpts)
end

U.merge = function(...)
    return vim.tbl_extend("force", ...)
end

U.req = function(path)
    local success, module = pcall(require, path)
    return success and module or nil
end

V = {}

V.isString = function(item) return type(item) == "string" end
V.isTable = function(item) return type(item) == "table" end

require("d.lazy.bootstrap")
