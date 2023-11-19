return {
    current = function()
        local filename  = vim.fn.expand('%:t')
        local extension = vim.fn.expand('%:e')
        print('getting current icon for', filename)
        local icon, color = require 'nvim-web-devicons'.get_icon_color(filename, extension)
        icon = (icon or '') .. ' '
        return icon, color
    end,
    bonus = {
        left_half_dome = '',
        right_half_dome = ''
    },

    diagnostics = {
        error = " ",
        warn = " ",
        hint = " ",
        info = " ",
    },
    git = {
        added = "  ",
        modified = "  ",
        removed = "  ",
    },
    lsp = {
        Array = "  ",
        Boolean = "  ",
        Class = "  ",
        Color = "  ",
        Constant = "󰏿  ",
        Constructor = "󱌢  ",
        Copilot = "  ",
        Enum = "  ",
        EnumMember = "  ",
        Event = "  ",
        Field = "  ",
        File = "  ",
        Folder = "  ",
        Function = "󰊕  ",
        Interface = "  ",
        Key = "  ",
        Keyword = "  ",
        Method = "󰡱  ",
        Module = "  ",
        Namespace = "󰰓  ",
        Null = "󰟢  ",
        Number = "  ",
        Object = "  ",
        Operator = "  ",
        Package = "  ",
        Property = "  ",
        Reference = "  ",
        Snippet = "  ",
        String = "  ",
        Struct = "  ",
        Text = "  ",
        TypeParameter = "  ",
        Unit = "  ",
        Value = "  ",
        Variable = "󰫧  ",
    }
}
