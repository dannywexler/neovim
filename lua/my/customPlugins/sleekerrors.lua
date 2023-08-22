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

local newDiagnostics             = {}
local virtErrorsNamespace        = api.nvim_create_namespace('virtErrors')
local space                      = ' '

local maxDiagnostics             = 800

local highlight_groups           = {
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

local function getDiagnostics(bufnr)
    local buf = bufnr or 0
    api.nvim_buf_clear_namespace(buf, virtErrorsNamespace, 0, -1)
    -- local startTime = vim.loop.hrtime()
    local allDiagnostics = vim.diagnostic.get(buf, {
        -- severity = vim.diagnostic.severity.ERROR
    })
    -- print("setting", #allDiagnostics, "diagnostics for", vim.fn.bufname(buf))
    if vim.tbl_isempty(allDiagnostics) or vim.tbl_count(allDiagnostics) > maxDiagnostics then return end

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

        if nonEmpty(virtLines) and lineNumber < vim.fn.line('$') then
            -- print("adding", #allDiagnostics, "diagnostics for", vim.fn.expand("%:t"))
            api.nvim_buf_set_extmark(buf, virtErrorsNamespace, lineNumber, 0, {
                virt_lines = virtLines,
            })
        end
    end
    -- local totalTime = tostring((vim.loop.hrtime() - startTime) / 1000000)
    -- print(("    SHOWING %s diagnostics for %s took: %s ms"):format(
    --     vim.tbl_count(allDiagnostics),
    --     vim.fn.bufname(buf),
    --     totalTime
    -- ))
    newDiagnostics[buf] = false
end

local function isDiagnosticFile(event)
    return vim.tbl_contains(fileTypesToShowDiagnostics, vim.bo[event.buf].filetype)
end

M.onCursorHold = function(event)
    -- if not isDiagnosticFile(event) then return end
    -- print("CursorHold", vim.fn.bufname(event.buf))
    for buf, needsUpdate in pairs(newDiagnostics) do
        if needsUpdate then
            -- print("  ", vim.fn.bufname(buf), "NEEDS to update diagnostics")
            getDiagnostics(buf)
        else
            -- print("  ", vim.fn.bufname(buf), "up to date diagnostics")
        end
    end
end

M.onDiagnosticChanged = function(event)
    -- if not isDiagnosticFile(event) then return end
    local buf = event.buf
    -- print("DiagnosticChanged", vim.fn.bufname(buf))
    if newDiagnostics[buf] == nil then
        getDiagnostics(buf)
    else
        newDiagnostics[buf] = true
    end
end

return M
