local filetypesToAutoFormat = { "lua", "typescript" }

---@class FormatOptions
---@field buf? integer
---@field auto? boolean

---@param opts? FormatOptions
return function(opts)
    opts = opts or {}
    local buf = opts.buf or 0
    local auto = opts.auto or false
    local ft = vim.bo[buf].ft
    if auto and not vim.tbl_contains(filetypesToAutoFormat, ft) then
        return
    end
    local errors = vim.diagnostic.count(buf)[vim.diagnostic.severity.ERROR] or 0
    if errors > 0 then
        return
    end
    vim.lsp.buf.format({ bufnr = buf })
end
