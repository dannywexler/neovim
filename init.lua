local api = vim.api
vim.g.mapleader = ' '
local myGroup = api.nvim_create_augroup('MyGroup', { clear = true })

---Prints any item
---@param ... unknown
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
    if success then return module end
    print('ERROR: Could not load module:', path)
end

---Adds item to table only if item not already in table
---@param tbl table
---@param item any
U.uadd = function(tbl, item)
    if vim.tbl_contains(tbl, item) then return end
    table.insert(tbl, item)
end

---Splits a string into its characters
---@param inputString string
---@return table
U.stringChars = function(inputString)
    local charsTable = {}
    for c in inputString:gmatch('%a') do
        table.insert(charsTable, c)
    end
    return charsTable
end

V = {}

---Checks if item is a function
---@param item any
---@return boolean
V.isFunction = function(item) return type(item) == 'function' end

---Checks if item is a string
---@param item any
---@return boolean
V.isString = function(item) return type(item) == "string" end

---Checks if item is a table
---@param item any
---@return boolean
V.isTable = function(item) return type(item) == "table" end

require("d.lazy.bootstrap")
