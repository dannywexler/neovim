return require("sleeklang").setup({
    json = {
        lsp = {
            jsonls = {}
        },
        plugins = { PLUG("schemastore") }
    },
    lua = {
        lsp = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "WINDOWS", "P", "U", "V", "LOG", "PLUG", "MERGE" },
                            -- neededFileStatus = {
                            -- ["no-unknown"] = "Any!"
                            -- }
                        },
                        telemetry = { enable = false },
                        workspace = { checkThirdParty = false },
                    },
                },
            },
        },
        plugins = { PLUG("folke/lazydev.nvim") }
    },
    yaml = {
        lsp = {
            yamlls = {}
        },
        plugins = { PLUG("schemastore") }
    }
})
