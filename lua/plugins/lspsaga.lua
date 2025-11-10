return PLUG("nvimdev/lspsaga.nvim", {
    event = "LspAttach",
    opts = {
        beacon = {
            enable = false
        },
        diagnostic = {
            extend_relatedInformation = true,
            show_code_action = true,
        },
        finder = {
            max_height = 0.8,
            left_width = 0.3,
            right_width = 0.6,
            default = "def+ref+imp",
        },
        lightbulb = {
            enable = false
        },
        symbol_in_winbar = {
            enable = false
        },
        ui = {
            border = vim.o.winborder
        }
    }
})
