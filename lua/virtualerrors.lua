local api = vim.api
local virtErrorsGroup = api.nvim_create_augroup('virtErrors', { clear = true })
local aucmd = api.nvim_create_autocmd
local virtErrorsNamespace = api.nvim_create_namespace('virtErrors')
local space = ' '
local warningIcon = ' '
local maxDiagnostics = 800

local highlight_groups = {
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

local owfMessage = "Property 'OWF' does not exist"

local function getDiagnostics()
    local allDiagnostics = vim.diagnostic.get(0, {
        -- severity = vim.diagnostic.severity.ERROR
    })
    if vim.tbl_isempty(allDiagnostics) or vim.tbl_count(allDiagnostics) > maxDiagnostics then return end

    local lineDiagnosticsMap = {}

    for _, diagnostic in ipairs(allDiagnostics) do
        if lineDiagnosticsMap[diagnostic.lnum] == nil then
            lineDiagnosticsMap[diagnostic.lnum] = {}
        end
        table.insert(lineDiagnosticsMap[diagnostic.lnum], diagnostic)
    end
    -- log(lineDiagnosticsMap)

    for lineNumber, diagGroup in pairs(lineDiagnosticsMap) do
        table.sort(diagGroup, function(a, b) return a.col < b.col end)
        local virtLines = {}
        local firstLinePieces = {}

        local endColOfLastPiece = 0
        for index, diagnostic in ipairs(diagGroup) do
            if not string.find(diagnostic.message, owfMessage) then
                local paddingWidth = diagnostic.col - endColOfLastPiece
                table.insert(firstLinePieces, {
                    space:rep(paddingWidth),
                    'CursorLine'
                })
                local diagnosticWidth = math.max(1, diagnostic.end_col - diagnostic.col)
                table.insert(firstLinePieces, {
                    string.rep(index, diagnosticWidth),
                    highlight_groups[diagnostic.severity]
                })
                endColOfLastPiece = diagnostic.col + diagnosticWidth
            end
        end
        -- if vim.tbl_count(firstLinePieces) > 0 then
        if nonEmpty(firstLinePieces) then
            table.insert(firstLinePieces, {
                space:rep(vim.fn.winwidth(0) - endColOfLastPiece),
                'CursorLine'
            })
            table.insert(virtLines, firstLinePieces)
        end


        for index, diagnostic in ipairs(diagGroup) do
            if not string.find(diagnostic.message, owfMessage) then
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
        end

        -- if vim.tbl_count(virtLines) > 0 then
        if nonEmpty(virtLines) then
            api.nvim_buf_set_extmark(0, virtErrorsNamespace, lineNumber, 0, {
                virt_lines = virtLines,
            })
        end
    end
end

aucmd('CursorHold', {
    pattern = { '*.json', '*.js', '*.lua', '*.rs', '*.ts', '*.tsx' },
    group = virtErrorsGroup,
    callback = function()
        api.nvim_buf_clear_namespace(0, virtErrorsNamespace, 0, -1)
        getDiagnostics()
    end
})


local mytable = {
    ['#fab'] = 'hello',
    [']'] = 'hello',
    _12abc = 'thing'
}