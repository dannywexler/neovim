local aucmd = vim.api.nvim_create_autocmd

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

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

aucmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
                notif.icon = ev.data.params.value.kind == "end" and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})
