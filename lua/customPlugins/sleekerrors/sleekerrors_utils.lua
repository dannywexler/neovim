local config = require('customPlugins.sleekerrors.sleekerrors_settings').config

local severity_num_to_string_map = {
    [vim.diagnostic.severity.ERROR] = "error",
    [vim.diagnostic.severity.WARN] = "warn",
    [vim.diagnostic.severity.INFO] = "info",
    [vim.diagnostic.severity.HINT] = "hint",
}

local M = {}
M.get_all_open_buffers = function()
    local all = vim.fn.getbufinfo({ bufloaded = 1, buflisted = 1 })
    local bufs = {}
    for _, buf in ipairs(all) do
        if #buf.windows > 0 then
            table.insert(bufs, buf.bufnr)
        end
    end
    return bufs
end

M.group_diagnostics = function(diagnostics)
    local line_diagnostics_map = {}
    for _, diagnostic in ipairs(diagnostics) do
        if line_diagnostics_map[diagnostic.lnum] == nil then
            line_diagnostics_map[diagnostic.lnum] = {}
        end
        table.insert(line_diagnostics_map[diagnostic.lnum], diagnostic)
    end
    return line_diagnostics_map
end

M.sort_diagnostics = function(diagnostics)
    table.sort(diagnostics, function(a, b)
        if a.col ~= b.col then return a.col < b.col end
        return a.severity < b.severity
    end)
end

M.filter_diagnostics = function(diagnostics)
    return vim.tbl_filter(function(diagnostic)
        for _, messageToIgnore in ipairs(config.ignore) do
            if diagnostic.message:find(messageToIgnore) then
                -- print(messageToIgnore .. ' found in ' .. message)
                return false
            end
        end
        -- print('keeping message: ' .. message)
        return true
    end, diagnostics)
end

M.add_spaces = function(source_table, num_of_spaces)
    table.insert(source_table, {
        (' '):rep(num_of_spaces),
        config.highlights.spacing
    })
end

M.get_diagnostic_highlight = function(diagnostic)
    local severity_string = severity_num_to_string_map[diagnostic.severity]
    return config.highlights[severity_string]
end

M.get_diagnostic_icon = function(diagnostic)
    local severity_string = severity_num_to_string_map[diagnostic.severity]
    return config.icons[severity_string]
end

return M
