---@module "sleeklang.lsp-types"

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
                ---@type lsptypes.settings.lua_ls
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "WINDOWS", "P", "U", "V", "PLUG", "MERGE" },
                            neededFileStatus = {
                                ["no-unknown"] = "Any!"
                            }
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
    nu = {},
    powershell = {
        enabled = WINDOWS,
        extra_filetypes = { "ps1" },
    },
    properties = {},
    python = {},
    regex = {},
    rust = { lsp = { rust_analyzer = {} } },
    sql = {},
    svelte = { lsp = { svelte = {} } },
    toml = { lsp = { taplo = {} } },
    typescript = {
        extra_filetypes = {
            "javascript",
            "javascriptreact",
            "typescriptreact"
        },
        lsp = {
            -- ---@type vim.lsp.Config
            -- ts7 = {
            --     cmd = function(dispatchers)
            --         local cmd = 'tsc'
            --         -- Dont really want to use local tsc for projects that arent using ts7
            --         -- if (config or {}).root_dir then
            --         --     local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
            --         --     if vim.fn.executable(local_cmd) == 1 then
            --         --         cmd = local_cmd
            --         --     end
            --         -- end
            --         return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
            --     end,
            --     filetypes = {
            --         'javascript',
            --         'javascriptreact',
            --         'typescript',
            --         'typescriptreact',
            --     },
            --     root_dir = function(bufnr, on_dir)
            --         local markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock',
            --             'package.json' }
            --         local project_root = vim.fs.root(bufnr, markers)
            --         if not project_root then
            --             vim.notify("TS7 could not find project root " .. vim.inspect(markers), vim.log.levels.WARN)
            --             return
            --         end
            --         on_dir(project_root)
            --     end,
            -- }
            vtsls = {
                ---@type lsptypes.settings.vtsls
                settings = {
                    ["js/ts"] = {
                        implicitProjectConfig = {
                            checkJs = true
                        },
                    },
                    vtsls = {
                        experimental = {
                            completion = {
                                enableServerSideFuzzyMatch = true
                            }
                        }
                    }
                },
            }
        }
    },
    vim = { extra_filetypes = { "vimdoc" } },
    xml = { lsp = { lemminx = {} } },
    yaml = { lsp = { yamlls = {} }, }
})
