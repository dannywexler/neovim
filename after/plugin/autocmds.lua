U.aucmd({ "BufLeave", "CursorHold" }, {
    callback = function(event)
        local bufopt = vim.bo[event.buf]

        if not bufopt.modifiable
            or #bufopt.buftype > 0
            or not bufopt.modified
            or #vim.fn.bufname(event.buf) == 0
        then
            return
        end
        vim.cmd('silent write')
    end
})

U.aucmd('VimResized', {
    command = 'wincmd ='
})

U.aucmd("WinLeave", {
    command = "setlocal nocursorline"
})

U.aucmd({ "BufEnter", "BufWinEnter", "VimEnter", "WinEnter" }, {
    command = "setlocal cursorline"
})
