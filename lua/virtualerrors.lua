local api = vim.api
local virtErrorsGroup = api.nvim_create_augroup('virtErrors', { clear = true })
local aucmd = api.nvim_create_autocmd
local virtErrorsNamespace = api.nvim_create_namespace('virtErrors')
local space = ' '
local warningIcon = ' '

local highlight_groups = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
    [vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
    [vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint",
}

local function clearVirtErrorNamespace()
    api.nvim_buf_clear_namespace(0, virtErrorsNamespace, 0, -1)
end

local function log(item)
    if type(item) == 'table' then
        print(vim.inspect(item))
    else
        print(item)
    end
end

local function getDiagnostics()
    local allDiagnostics = vim.diagnostic.get(0, {
        -- severity = vim.diagnostic.severity.ERROR
    })
    if vim.tbl_isempty(allDiagnostics) then return end
    for _, diagnostic in ipairs(allDiagnostics) do
        -- log(diagnostic.message)
        api.nvim_buf_set_extmark(0, virtErrorsNamespace, diagnostic.lnum, 0, {
            virt_lines = {
                {
                    {
                        -- space:rep(diagnostic.col) .. warningIcon .. ' ' .. diagnostic.message .. ' ' .. warningIcon,
                        space:rep(2) .. warningIcon .. ' ' .. diagnostic.message .. ' ' .. warningIcon,
                        highlight_groups[diagnostic.severity]
                    },
                }
            },
        })
    end
end

aucmd('CursorHold', {
    pattern = { '*.lua', '*.ts' },
    group = virtErrorsGroup,
    callback = function()
        clearVirtErrorNamespace()
        getDiagnostics()
    end
})
