local M                          = {}
local api                        = vim.api
local fileTypesToShowDiagnostics = {
    'java',
    'javascript',
    'json',
    'lua',
    'rust',
    'typescript',
}


M.newDiagnostics          = {}
local virtErrorsNamespace = api.nvim_create_namespace('virtErrors')
local space               = ' '
local indent              = "   "

local maxDiagnostics      = 800

local highlight_groups    = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
    [vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
    [vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint",
}

local function log(item)
    if type(item) == 'table' then
        print(vim.inspect(item))
    else
        print(item)
    end
end

local function nonEmpty(item)
    return not vim.tbl_isempty(item)
end

local messagesToIgnore = {
    "Property 'OWF' does not exist",
    "implicitly has an 'any' type",
    "JSDOC types may be moved to TypeScript types",
    -- "Unused functions"
}

local function shouldKeepDiagnostic(diagnostic)
    for _, messageToIgnore in ipairs(messagesToIgnore) do
        if diagnostic.message:find(messageToIgnore) then
            -- print(messageToIgnore .. ' found in ' .. message)
            return false
        end
    end
    -- print('keeping message: ' .. message)
    return true
end

M.getDiagnostics = function(bufnr)
    local buf = bufnr or 0
    -- local needsUpdate = M.newDiagnostics[buf]
    -- if needsUpdate == nil then needsUpdate = true end
    -- if not needsUpdate then
    --     -- print(_G.fileName(buf), "is already up to date")
    --     return
    -- end
    api.nvim_buf_clear_namespace(buf, virtErrorsNamespace, 0, -1)
    -- M.newDiagnostics[buf] = false
    local startTime = vim.loop.hrtime()
    local allDiagnostics = vim.diagnostic.get(buf, {
        -- severity = vim.diagnostic.severity.ERROR
    })
    -- print("recieved", #allDiagnostics, "diagnostics for", _G.fileName(buf))
    if vim.tbl_isempty(allDiagnostics) or vim.tbl_count(allDiagnostics) > maxDiagnostics then
        -- print(_G.fileName(buf), "doesn't have any diagnostics")
        return
    end

    local lineDiagnosticsMap = {}

    for _, diagnostic in ipairs(allDiagnostics) do
        if shouldKeepDiagnostic(diagnostic) then
            if lineDiagnosticsMap[diagnostic.lnum] == nil then
                lineDiagnosticsMap[diagnostic.lnum] = {}
            end
            table.insert(lineDiagnosticsMap[diagnostic.lnum], diagnostic)
        end
    end
    -- log(lineDiagnosticsMap)

    for lineNumber, diagGroup in pairs(lineDiagnosticsMap) do
        table.sort(diagGroup, function(a, b) return a.col < b.col end)
        local virtLines = {}
        local firstLinePieces = {}

        local endColOfLastPiece = 0
        for index, diagnostic in ipairs(diagGroup) do
            local paddingWidth = diagnostic.col - endColOfLastPiece
            table.insert(firstLinePieces, {
                space:rep(paddingWidth),
                -- 'CursorLine'
                'Normal'
            })
            local diagnosticWidth = math.max(1, diagnostic.end_col - diagnostic.col)
            table.insert(firstLinePieces, {
                string.rep(index, diagnosticWidth),
                highlight_groups[diagnostic.severity]
            })
            endColOfLastPiece = diagnostic.col + diagnosticWidth
        end
        if nonEmpty(firstLinePieces) then
            table.insert(firstLinePieces, {
                space:rep(vim.fn.winwidth(0) - endColOfLastPiece),
                -- 'CursorLine'
                'Normal'
            })
            table.insert(virtLines, firstLinePieces)
        end


        for index, diagnostic in ipairs(diagGroup) do
            local formattedMessage = '  ' .. index .. '. ' .. diagnostic.message
            local remainingLength = math.max(1, vim.fn.winwidth(0) - #formattedMessage)
            formattedMessage = formattedMessage .. space:rep(remainingLength)
            table.insert(virtLines, {
                {
                    formattedMessage,
                    highlight_groups[diagnostic.severity]
                },
            })
        end

        if nonEmpty(virtLines) then
            -- print("adding", #allDiagnostics, "diagnostics for", vim.fn.expand("%:t"))
            -- print(_G.fileName(buf), indent, "Added", #virtLines - 1, "msgs to line", lineNumber)
            api.nvim_buf_set_extmark(buf, virtErrorsNamespace, lineNumber, 0, {
                virt_lines = virtLines,
            })
        end
    end
    -- local totalTime = tostring((vim.loop.hrtime() - startTime) / 1000000)
    -- print(indent, ("SHOWING %s diagnostics for %s took: %s ms"):format(
    --     vim.tbl_count(allDiagnostics),
    --     _G.fileName(buf),
    --     totalTime
    -- ))
    -- print(_G.fileName(buf), "SHOWING", #allDiagnostics, "diagnostics took", totalTime, "ms")
end

M.getAllDiagnostics = function()
    for _, buf in ipairs(_G.allBufs()) do
        -- print("Getting diagnostics for buf", buf, ": ", _G.fileName(buf))
        -- print(vim.inspect(M.newDiagnostics))
        M.getDiagnostics(buf)
    end
end

local function isDiagnosticFile(event)
    return vim.tbl_contains(fileTypesToShowDiagnostics, vim.bo[event.buf].filetype)
end

M.onCursorHold = function(event)
    -- if not isDiagnosticFile(event) then return end
    print("CursorHold", _G.fileName(event.buf))
    -- print(vim.inspect(M.newDiagnostics))
    -- local allBufs = vim.fn.getbufinfo({ bufloaded = 1 })
    -- local loadedBufs = vim.tbl_filter(function(bufEntry)
    --     if bufEntry.loaded == 1 and bufEntry.listed == 1 then
    --         return true
    --     end
    --     return false
    -- end, allBufs)

    for buf, needsUpdate in pairs(M.newDiagnostics) do
        -- if vim.tbl_contains(loadedBufs, buf) and needsUpdate then
        if needsUpdate then
            print("  ", _G.fileName(buf), "NEEDS to update diagnostics")
            M.getDiagnostics(buf)
        else
            print("  ", _G.fileName(buf), "up to date diagnostics")
        end
    end
end

M.onDiagnosticChanged = function(event)
    -- if not isDiagnosticFile(event) then return end
    local buf = event.buf
    -- local diagnosticsCount = #event.data.diagnostics
    -- local mode = vim.fn.mode()
    -- print("DiagnosticChanged in", mode, "mode:", _G.fileName(buf), "now has", diagnosticsCount, "diagnostics")
    M.newDiagnostics[buf] = true
    -- if mode == "n" then
    --     M.getDiagnostics(buf)
    -- end
    -- if M.newDiagnostics[buf] == nil or mode == "n" then
    --     M.getDiagnostics(buf)
    -- else
    --     M.newDiagnostics[buf] = true
    -- end
    -- print(vim.inspect(M.newDiagnostics))
end

_G.allBufs = function()
    local all = vim.fn.getbufinfo({ bufloaded = 1, buflisted = 1 })
    local bufs = {}
    for _, buf in ipairs(all) do
        if #buf.windows > 0 then
            table.insert(bufs, buf.bufnr)
        end
    end
    return bufs
end

_G.fileName = function(buf)
    buf = buf or 0
    local full = vim.fn.bufname(buf)
    local cleaned = vim.fn.fnamemodify(full, ":t")
    return cleaned
end

return M
