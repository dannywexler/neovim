local diagnostics_have_changed = false
local function get_buf_name(bufnr)
    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr or 0), ":t")
end

---@param original vim.Diagnostic
local function simple_diagnostic(original)
    return {
        code = original.code,
        col = original.col,
        end_col = original.end_col,
        end_lnum = original.end_lnum,
        lnum = original.lnum,
        message = original.message,
        severity = original.severity,
    }
end

---@type table<number, table<number,vim.Diagnostic>>
local diagnostics_map = {}

---@param changed_diagnostics vim.Diagnostic[]
local function on_diagnostic_changed(changed_diagnostics)
    -- LOG("on_diagnostic_changed got", #changed_diagnostics, "total diagnostics")
    diagnostics_have_changed = true
    diagnostics_map = {}
    for _, changed_diagnostic in ipairs(changed_diagnostics) do
        local buf = changed_diagnostic.bufnr or 1
        local line = changed_diagnostic.lnum
        local buf_diagnostics = diagnostics_map[buf] or {}
        local line_diagnostics = buf_diagnostics[line] or {}
        table.insert(line_diagnostics, simple_diagnostic(changed_diagnostic))
        buf_diagnostics[line] = line_diagnostics
        diagnostics_map[buf] = buf_diagnostics
    end
    -- LOG("on_diagnostic_changed got changed_diagnostics:", changed_diagnostics)
    for bufnr, buffer_diagnostics in pairs(diagnostics_map) do
        local buf_diagnostics_count = 0
        for _, line_diagnostics in pairs(buffer_diagnostics) do
            buf_diagnostics_count = buf_diagnostics_count + #line_diagnostics
        end
        -- LOG("on_diagnostic_changed", get_buf_name(bufnr), "has", buf_diagnostics_count, "diagnostics")
    end
    -- LOG("on_diagnostic_changed diagnostics_map:", diagnostics_map)
end

---@param line_diagnostics vim.Diagnostic[]
---@param winwidth number
local function update_line(line_diagnostics, winwidth)
    local previous_end_col = 0

    -- while advancing, need to keep updating previous_end_col, and need to keep proceeding further until find an item where item.col > previous_end_col
end

---@param wininfo vim.fn.getwininfo.ret.item
---@param buf_diagnostics table<number, vim.Diagnostic[]>
local function update_buf(wininfo, buf_diagnostics)
    local buf_name = get_buf_name(wininfo.bufnr)
    if buf_diagnostics == nil then
        -- LOG("update_buf", buf_name, "SKIPPED")
        return
    end
    -- LOG("update_buf", buf_name, "has diagnostics")
    for line, line_diagnostics in ipairs(buf_diagnostics) do
        if line < wininfo.topline or line > wininfo.botline then return end
        table.sort(line_diagnostics, function(a, b)
            if a.col < b.col then return true end
            return a.severity < b.severity
        end)

        update_line(line_diagnostics, wininfo.width)
    end
end

local function update()
    if not diagnostics_have_changed then return end

    for _, wininfo in ipairs(vim.fn.getwininfo()) do
        update_buf(wininfo, diagnostics_map[wininfo.bufnr])
    end

    diagnostics_have_changed = false
end

local function setup()
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
        callback = function(event)
            on_diagnostic_changed(event.data.diagnostics)
        end
    })

    vim.api.nvim_create_autocmd("CursorHold", {
        callback = function() update() end
    })
end

return {
    run = update,
    setup = setup,
}
