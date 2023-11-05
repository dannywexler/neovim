return {
    bash = {},
    c = {},
    cpp = {},
    css = {},
    csv = {},
    html = {},
    java = {},
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
    jsdoc = {},
    json = {},
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
    markdown = {},
    markdown_inline = {},
    nix = {},
    python = {},
    regex = {},
    rust = {},
    svelte = {},
    toml = {},
    tsx = {},
    typescript = {},
    vim = {},
    vimdoc = {},
    xml = {},
    yaml = {},
}
