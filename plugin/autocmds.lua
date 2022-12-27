local api = vim.api
local aucmd = api.nvim_create_autocmd
local myGroup = api.nvim_create_augroup('MyGroup', { clear = true })

aucmd({ 'BufLeave', 'CursorHold'}, {
    group = myGroup,
    pattern = '*.*',
    callback = function ()
        vim.cmd('silent update')
        vim.diagnostic.open_float()
    end
})

aucmd('VimResized', {
    group = myGroup,
    callback = function ()
        vim.cmd('wincmd =')
    end
})
