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
        lightbulb = {
            enable = false
        },
        symbol_in_winbar = {
            enable = false
        },
        ui = {
            border = "bold"
        }
    }
})
