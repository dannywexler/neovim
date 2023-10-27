local languages_config = require('d.languages')
local langs_with_lsps  = {}
local lsp_settings     = {}
for language, language_config in vim.spairs(languages_config) do
    local lsp_config_tbl = language_config.lsp
    if lsp_config_tbl then
        table.insert(langs_with_lsps, language)
        for lsp_name, lsp_config in vim.spairs(lsp_config_tbl) do
            lsp_settings[lsp_name] = lsp_config
        end
    end
end
P('langs_with_lsps', langs_with_lsps)
P('MERGED lsp_settings', lsp_settings)
return {
    dependencies = {
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
        'folke/neodev.nvim',
        {
            'folke/neoconf.nvim',
            ft = { 'lua', 'json' },
            opts = {
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
        },
        'hrsh7th/cmp-nvim-lsp',
    },
    ft = langs_with_lsps,
    config = function()
        require('neodev').setup {}

        local capabilities            = vim.lsp.protocol.make_client_capabilities()
        capabilities                  = require('cmp_nvim_lsp').default_capabilities(capabilities)
        local default_server_settings = { capabilities = capabilities }


        require 'mason-lspconfig'.setup {
            automatic_installation = false,
            ensure_installed = vim.tbl_keys(lsp_settings),
            handlers = {
                function(lsp_name)
                    -- print("setting up ", server_name)
                    local mergedConfig = U.merge(
                        default_server_settings,
                        lsp_settings[lsp_name]
                    )
                    P('FINAL merged lang server configs', mergedConfig)
                    require('lspconfig')[lsp_name].setup(mergedConfig)
                end
            }
        }
    end
}
