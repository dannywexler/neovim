local api = vim.api
local myGroup = api.nvim_create_augroup('MyGroup', { clear = true })

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
