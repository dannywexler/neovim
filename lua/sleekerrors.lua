local logger = require("utils.log").create_logger("SleekErrors")

-- local example_diagnostic = {
--     bufnr = 33,
--     code = "unused-local",
--     col = 6,
--     end_col = 28,
--     end_lnum = 0,
--     lnum = 0,
--     message = "Unused local `sleek_errors_namespace`.",
--     namespace = 13,
--     severity = 4,
--     source = "Lua Diagnostics.",
-- }
--
-- local example_wininfo = {
--     botline = 61,
--     bufnr = 25,
--     height = 67,
--     leftcol = 0,
--     loclist = 0,
--     quickfix = 0,
--     tabnr = 1,
--     terminal = 0,
--     textoff = 0,
--     topline = 1,
--     variables = vim.empty_dict(),
--     width = 106,
--     winbar = 1,
--     wincol = 1,
--     winid = 1002,
--     winnr = 1,
--     winrow = 1
-- }

---@class SleekErrorBufContext
---@field buf number
---@field ft string
---@field win_width number
---@field diagnostics vim.Diagnostic[]

---@class SleekErrorLineContext
---@field line number
---@field buf number
---@field ft string
---@field win_width number
---@field diagnostics vim.Diagnostic[]

---@param count number?
local function spaces(count)
    return (" "):rep(count or 200)
end

local highlight_groups = { "SleekErrorsError", "SleekErrorsWarn", "SleekErrorsInfo", "SleekErrorsHint" }

---@type table<number, table<vim.Diagnostic>>
local diagnostics_map = {}

local namespace = vim.api.nvim_create_namespace("SleekErrors")

local function get_buf_name(bufnr)
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr or 0), ":t")
    return ("%-40s"):format(name)
end

---@param buf number
---@param changed_diagnostics vim.Diagnostic[]
local function on_diagnostic_changed(buf, changed_diagnostics)
    local log = logger("on_diagnostic_changed")
    local diagnostics_count = #changed_diagnostics
    local bufname = get_buf_name(buf)
    if diagnostics_count > 0 then
        log("Buf", buf, "named", bufname, "now has", diagnostics_count, "diagnostics")
    else
        log("Buf", buf, "named", bufname, "no longer has any diagnostics")
    end
    diagnostics_map[buf] = changed_diagnostics
    -- log("diagnostics_map:", diagnostics_map)
end

---@param ctx SleekErrorLineContext
local function render_line(ctx)
    -- local log = logger("render_line")
    ---@type table<[string, string]>
    local virt_lines = {}
    table.sort(ctx.diagnostics, function(diagnostic_a, diagnostic_b)
        if diagnostic_a.col ~= diagnostic_b.col then
            return diagnostic_a.col < diagnostic_b.col
        end
        return diagnostic_a.severity < diagnostic_b.severity
    end)
    local first_line_pieces = {}
    local pieces = {}

    local index = 1
    local endColOfLastPiece = 0

    for _, diagnostic in ipairs(ctx.diagnostics) do
        local highlight = highlight_groups[diagnostic.severity]
        -- if two diagnostics overlap, skip them
        if diagnostic.col == 0 or diagnostic.col > endColOfLastPiece then
            -- first line pieces
            local paddingWidth = diagnostic.col - endColOfLastPiece
            table.insert(first_line_pieces, { spaces(paddingWidth), "Normal", })

            local diagnosticWidth = math.max(1, diagnostic.end_col - diagnostic.col)
            local indicator = string.rep(index, diagnosticWidth)
            table.insert(first_line_pieces, { indicator, highlight, })

            -- each line of each diagnostic
            for new_line_index, new_line_msg in ipairs(vim.split(diagnostic.message, "\n")) do
                local prefix = "    "
                if new_line_index == 1 then
                    prefix = " " .. index .. ". "
                end
                local message = prefix .. new_line_msg .. " "
                -- log(get_buf_name(ctx.buf), "Line:", ctx.line, "Adding", hl, "message:", message)
                table.insert(pieces, { { message, highlight } })
            end

            endColOfLastPiece = diagnostic.col + diagnosticWidth
            index = index + 1
        end
    end

    table.insert(virt_lines, first_line_pieces)
    for _, piece in ipairs(pieces) do
        table.insert(virt_lines, piece)
    end

    local opts = { virt_lines = virt_lines }
    -- log(opts)
    vim.api.nvim_buf_set_extmark(ctx.buf, namespace, ctx.line, 0, opts)
end

---@param ctx SleekErrorBufContext
local function render_buf(ctx)
    -- local log = logger("render_buf")
    vim.api.nvim_buf_clear_namespace(ctx.buf, namespace, 0, -1)
    ---@type table<number, vim.Diagnostic[]>
    local line_diagnostics_map = {}
    -- local buf_name = get_buf_name(wininfo.bufnr)
    -- log("render_buf", buf_name, "has diagnostics")
    for _, diagnostic in ipairs(ctx.diagnostics) do
        local line = diagnostic.lnum
        local all_line_diagnostics = line_diagnostics_map[line] or {}
        table.insert(all_line_diagnostics, diagnostic)
        line_diagnostics_map[line] = all_line_diagnostics
    end

    for linenum, line_diagnostics in pairs(line_diagnostics_map) do
        render_line({
            buf = ctx.buf,
            ft = ctx.ft,
            line = linenum,
            win_width = ctx.win_width,
            diagnostics = line_diagnostics,
        })
    end
end

local function render()
    for _, wininfo in ipairs(vim.fn.getwininfo()) do
        local buf = wininfo.bufnr
        local changed_diagnostics = diagnostics_map[buf]
        local ft = vim.bo[buf].ft
        if changed_diagnostics then
            render_buf({
                buf = buf,
                ft = ft,
                win_width = wininfo.width,
                diagnostics = changed_diagnostics
            })
        end
    end
end

local function setup()
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
        callback = function(event)
            on_diagnostic_changed(event.buf, event.data.diagnostics)
        end
    })

    vim.api.nvim_create_autocmd("CursorHold", {
        callback = render
    })
end

return {
    run = render,
    setup = setup,
}
