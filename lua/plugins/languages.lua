vim.diagnostic.config({
    -- virtual_lines = false,
    signs = false,
})

return require("sleeklang").setup({
    bash = { extra_filetypes = { "sh" }, lsp = { bashls = {} } },
    c = {},
    comment = {},
    cpp = {},
    css = { lsp = { cssls = {} } },
    csv = {},
    dockerfile = {},
    editorconfig = {},
    git_config = {
        extra_filetypes = {
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
        },
    },
    groovy = {},
    html = { lsp = { html = {} } },
    ini = {},
    java = { extra_filetypes = { "javadoc" } },
    jsdoc = {},
    json = { extra_filetypes = { "jsonc" }, lsp = { jsonls = {} } },
    lua = {
        extra_filetypes = { "luadoc" },
        lsp = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "WINDOWS", "P", "U", "V", "PLUG", "MERGE" },
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
    markdown = { extra_filetypes = { "markdown_inline" }, lsp = { marksman = {} } },
    nu = { lsp = { nushell = {} } },
    powershell = {
        enabled = WINDOWS,
        extra_filetypes = { "ps1" },
        lsp = {
            powershell_es = {
                shell = "powershell.exe",
                bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
            },
        },
    },
    properties = {},
    python = {},
    regex = {},
    rust = {},
    sql = {},
    svelte = { lsp = { svelte = {} } },
    toml = { lsp = { taplo = {} } },
    typescript = {
        extra_filetypes = {
            "javascript",
            "javascriptreact",
            "jsx",
            "tsx",
            "typescriptreact"
        },
        -- plugins = { require("my.typescript_tools") }
        lsp = {
            ts_ls = {
                settings = {
                    implicitProjectConfiguration = {
                        checkJs = true,
                    },
                },
            }
        }
    },
    vim = { extra_filetypes = { "vimdoc" } },
    xml = { lsp = { lemminx = {} } },
    yaml = { lsp = { yamlls = {} }, }
})
