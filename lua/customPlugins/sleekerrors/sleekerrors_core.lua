local utils = require('customPlugins.sleekerrors.sleekerrors_utils')
local config = require('customPlugins.sleekerrors.sleekerrors_settings').config
local M = {}
local sleekerrors_namespace = vim.api.nvim_create_namespace('virtErrors')


local function assemble_first_line_pieces(diagnostics)
    local first_line_pieces = {}
    local end_col_of_last_piece = 0
    for index, diagnostic in ipairs(diagnostics) do
        local left_padding = diagnostic.col - end_col_of_last_piece
        utils.add_spaces(first_line_pieces, left_padding)

        local diagnostic_width = math.max(1, diagnostic.end_col - diagnostic.col)
        table.insert(first_line_pieces, {
            string.rep(index, diagnostic_width),
            utils.get_diagnostic_highlight(diagnostic)
        })
        end_col_of_last_piece = diagnostic.col + diagnostic_width
    end
    utils.add_spaces(first_line_pieces, 40)
    return first_line_pieces
end

local function render_line_diagnostics(bufnr, line_number, diagnostics)
    local context = table.concat({
        'render_line_diagnostics ->',
        vim.fn.bufname(bufnr),
        '(',
        bufnr,
        ') at line',
        line_number,
    }, ' ')
    P(context, 'got', #diagnostics, 'diagnostics to render:', diagnostics)

    local virt_lines = {}
    local first_line_pieces = assemble_first_line_pieces(diagnostics)
    P(context, 'first_line_pieces', first_line_pieces)
    table.insert(virt_lines, first_line_pieces)

    for index, diagnostic in ipairs(diagnostics) do
        local formatted_message = config.format_message(
            diagnostic,
            index,
            utils.get_diagnostic_icon(diagnostic)
        )
        table.insert(virt_lines, {
            {
                formatted_message,
                utils.get_diagnostic_highlight(diagnostic)
            },
        })
    end

    P(context, 'virt_lines:', virt_lines)

    vim.api.nvim_buf_set_extmark(
        bufnr,
        sleekerrors_namespace,
        line_number,
        0,
        { virt_lines = virt_lines }
    )
end

M.render_all_diagnostics = function()
    for _, bufnr in ipairs(utils.get_all_open_buffers()) do
        P('render_all_diagnostics', bufnr, vim.fn.bufname(bufnr))
        M.clear_buffer_diagnostics(bufnr)
        M.render_buffer_diagnostics(bufnr)
    end
end

M.clear_buffer_diagnostics = function(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, sleekerrors_namespace, 0, -1)
end

M.render_buffer_diagnostics = function(bufnr)
    local context = table.concat({
        'render_buffer_diagnostics ->',
        vim.fn.bufname(bufnr),
        '(',
        bufnr,
        ')',
    }, ' ')
    local buffer_diagnostics = vim.diagnostic.get(bufnr)
    P(context, 'has', #buffer_diagnostics, 'diagnostics')
    if #buffer_diagnostics == 0 then return end

    local filtered_diagnostics = utils.filter_diagnostics(buffer_diagnostics)
    -- P(context, 'filtered_diagnostics', filtered_diagnostics)
    local line_diagnostics_map = utils.group_diagnostics(filtered_diagnostics)
    -- P(context, 'line_diagnostics_map', line_diagnostics_map)

    for line_number, diagnostics in pairs(line_diagnostics_map) do
        utils.sort_diagnostics(diagnostics)
        render_line_diagnostics(bufnr, line_number, diagnostics)
    end
end

return M
