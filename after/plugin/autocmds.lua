-- print('hello from autocmds')
--
-- how to know when to save a file:
-- if vim.bo.buflisted and vim.bo.buftype == ''
-- or maybe just check  vim.bo.modified?

local api = vim.api
local myGroup = api.nvim_create_augroup('MyGroup', { clear = true })
local aucmd = function(event, opts)
    local defaultOpts = { group = myGroup }
    local mergedOpts = vim.tbl_extend('force', defaultOpts, opts)

    api.nvim_create_autocmd(event, mergedOpts)
end

local filetypesToAutoFormat = { 'lua' }

local function formatFile(buf, bufopt)
    local ft = bufopt.ft
    if not vim.tbl_contains(filetypesToAutoFormat, ft) then return end
    local errorCount = vim.tbl_count(vim.diagnostic.get(buf, {
        severity = vim.diagnostic.severity.ERROR
    }))
    if errorCount > 0 then return end
    vim.lsp.buf.format({ bufnr = buf })
end

aucmd({ 'BufLeave', 'CursorHold' }, {
    callback = function(event)
        local bufopt = vim.bo[event.buf]
        if not bufopt.modifiable then return end
        if #bufopt.buftype > 0 then return end
        if not bufopt.modified then return end
        formatFile(event.buf, bufopt)
        vim.cmd('silent write')
    end
})

aucmd('VimResized', {
    command = 'wincmd ='
})

aucmd({ "BufEnter", "BufWinEnter", "VimEnter", "WinEnter" }, {
    command = "setlocal cursorline"
})

aucmd("WinLeave", {
    command = "setlocal nocursorline"
})
