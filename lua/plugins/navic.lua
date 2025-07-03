return PLUG("SmiteshP/nvim-navic", {
    event = "LspAttach",
    opts = {
        icons = require("my.icons").lsp,
        lsp = {
            auto_attach = true
        },
        separator = " " .. require("my.icons").misc.greater .. " ",
    }
})
