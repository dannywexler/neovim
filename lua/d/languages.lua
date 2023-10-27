return {
    lua = {
        lsp = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "WINDOWS", "P", "U", "V" },
                            -- neededFileStatus = {
                            --     ["no-unknown"] = "Any!"
                            -- }
                        },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    }
                },
            },
        },
    },
    javascript = {
        lsp = {
            tsserver = {
                settings = {
                    implicitProjectConfiguration = {
                        checkJs = true
                    }
                }
            },
        }
    },
    typescript = {}
}
