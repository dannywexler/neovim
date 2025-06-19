local aucmd = vim.api.nvim_create_autocmd

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local function saveFile(event)
    local buf = event.buf
    local bufopt = vim.bo[buf]

    if
        not bufopt.modifiable
        or not bufopt.modified
        or #bufopt.buftype > 0
        or #vim.fn.bufname(buf) == 0
    then
        return
    end
    require("utils.format")({ buf = buf, auto = true })
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

aucmd("FileType", {
    pattern = "help",
    callback = function()
        vim.cmd.wincmd("L")
    end,
})
