U.aucmd({ "BufLeave", "CursorHold" }, {
    command = "silent update"
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
