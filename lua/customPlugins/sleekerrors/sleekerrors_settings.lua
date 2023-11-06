local M = {}

M.config = {
    builtin_diagnostic_overrides = {
        virtual_text = false,
        signs = false,
        update_in_insert = false,
    },
    format_message = function(diagnostic, index, icon)
        return ('%s %s. %s'):format(icon, index, diagnostic.message) .. (' '):rep(400)
    end,
    highlights = {
        error = "DiagnosticVirtualTextError",
        warn = "DiagnosticVirtualTextWarn",
        info = "DiagnosticVirtualTextInfo",
        hint = "DiagnosticVirtualTextHint",
        spacing = "Normal"
    },
    icons = {
        error = " ",
        warn = " ",
        hint = " ",
        info = " ",
    },
    ignore = {
        "Unused functions"
    },
}

M.setup = function(user_opts)
    P('sleekerrors_settings received user_opts:', user_opts)
    M.config = U.merge(M.config, user_opts)
    vim.diagnostic.config(M.config.builtin_diagnostic_overrides)
end

return M
