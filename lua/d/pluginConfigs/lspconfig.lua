local languages = {
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

return {
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'folke/neodev.nvim',
        'folke/neoconf.nvim',
        'hrsh7th/cmp-nvim-lsp',
    },
    ft = vim.tbl_keys(languages),
    config = function()
        require 'neodev'.setup()
        require 'neoconf'.setup {
            plugins = {
                lspconfig = {
                    enabled = true,
                },
                jsonls = {
                    enabled = true,
                    configured_servers_only = true,
                },
                lua_ls = {
                    enabled_for_neovim_config = true,
                    enabled = true,
                },
            },
        }
        require 'mason'.setup()

        local capabilities                = vim.lsp.protocol.make_client_capabilities()
        capabilities                      = require('cmp_nvim_lsp').default_capabilities(capabilities)
        local default_lsp_settings        = { capabilities = capabilities }
        local all_language_server_configs = {}

        for language, config in vim.spairs(languages) do
            if config.lsp then
                P('Language:', language, 'has lsp config:', config.lsp)
                all_language_server_configs = U.merge(all_language_server_configs, config.lsp)
            end
        end

        P('FINAL merged lang server configs', all_language_server_configs)

        require 'mason-lspconfig'.setup {
            automatic_installation = false,
            ensure_installed = vim.tbl_keys(all_language_server_configs),
            handlers = {
                function(server_name)
                    -- print("setting up ", server_name)
                    local mergedConfig = U.merge(
                        default_lsp_settings,
                        all_language_server_configs[server_name]
                    )
                    require('lspconfig')[server_name].setup(mergedConfig)
                end
            }
        }
    end
}
