-- print('hello from autocmds')

-- local api = vim.api
-- local myGroup = api.nvim_create_augroup('MyGroup', { clear = true })
-- local aucmd = api.nvim_create_autocmd

-- api.nvim_create_autocmd({ 'BufLeave', 'CursorHold' }, {
--     group = myGroup,
--     pattern = '*.*',
--     callback = function()
--         vim.cmd('silent update')
--     end
-- })

-- aucmd({ 'BufLeave', 'CursorHold' }, {
--     group = myGroup,
--     pattern = '*.*',
--     callback = function()
--         vim.cmd('silent update')
--         -- vim.diagnostic.open_float()
--     end
-- })
--
-- aucmd('VimResized', {
--     group = myGroup,
--     callback = function()
--         vim.cmd('wincmd =')
--     end
-- })
--
vim.cmd [[

augroup SaveFile
autocmd!
autocmd BufLeave,CursorHold *.* silent update
augroup END

augroup WindowResized
autocmd!
autocmd VimResized * wincmd =
augroup END

]]
