local aucmd = vim.api.nvim_create_autocmd

local filetypesToAutoFormat = { "lua", "typescript" }

local function formatFile(buf, bufopt)
    local ft = bufopt.ft
    if not vim.tbl_contains(filetypesToAutoFormat, ft) then
        return
    end
    local errors = vim.diagnostic.count(buf)[vim.diagnostic.severity.ERROR] or 0
    if errors > 0 then
        return
    end
    vim.lsp.buf.format({ bufnr = buf })
end

local function saveFile(event)
    local bufopt = vim.bo[event.buf]

    if
        not bufopt.modifiable
        or not bufopt.modified
        or #bufopt.buftype > 0
        or #vim.fn.bufname(event.buf) == 0
    then
        return
    end
    formatFile(event.buf, bufopt)
    vim.cmd("silent write")
    -- sleekerrors.getAllDiagnostics()
    -- sleekerrors.onCursorHold(event)
    -- sleekerrors.getDiagnostics(event.buf)
end

aucmd("BufLeave", {
    callback = saveFile,
})

aucmd("CursorHold", {
    callback = saveFile,
})

aucmd("VimResized", {
    command = "wincmd =",
})

aucmd({ "BufEnter", "BufWinEnter", "VimEnter", "WinEnter" }, {
    command = "setlocal cursorline",
})

aucmd("WinLeave", {
    command = "setlocal nocursorline",
})
