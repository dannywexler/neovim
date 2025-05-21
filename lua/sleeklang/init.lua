---@class sleeklang.LanguageOptions
---@field enabled? boolean | fun():boolean
---@field extra_filetypes? string[]
---@field lsp? table | function
---@field plugins? PluginSpec[]

local all_treesitter_filetypes = require("sleeklang.treesitter_filetypes")

return {
    ---@param config table<sleeklang.FileType, sleeklang.LanguageOptions>
    ---@return LazySpec[]
    setup = function(config)
        local lazy_specs = {}
        local enabled_treesitter_filetypes = {}
        local enabled_lsp_filetypes = {}
        local enabled_lsps = {}
        local enabled_tools = {}

        for filetype, language_config in pairs(config) do
            local lang_filetypes = {}
            table.insert(lang_filetypes, filetype)
            for _, extra_filetype in ipairs(language_config.extra_filetypes or {}) do
                table.insert(lang_filetypes, extra_filetype)
            end
            for _, ft in ipairs(lang_filetypes) do
                if vim.tbl_contains(all_treesitter_filetypes, ft) then
                    table.insert(enabled_treesitter_filetypes, ft)
                end
            end
            local lsp_cfg = language_config.lsp
            if type(lsp_cfg) == "table" then
                for lsp_name, lsp_opts in pairs(lsp_cfg) do
                    -- LOG("lsp_name:", lsp_name, "with lsp_opts:", lsp_opts)
                    enabled_lsps[lsp_name] = lsp_opts
                    table.insert(enabled_tools, lsp_name)
                end
                for _, lang_filetype in ipairs(lang_filetypes) do
                    table.insert(enabled_lsp_filetypes, lang_filetype)
                end
            end
            if (language_config.plugins) then
                table.insert(lazy_specs, vim.tbl_map(function(original_spec)
                    if vim.tbl_isempty(lang_filetypes) then
                        return original_spec
                    else
                        return MERGE({ ft = lang_filetypes }, original_spec)
                    end
                end, language_config.plugins))
            end
        end

        table.insert(lazy_specs, PLUG("nvim-treesitter/nvim-treesitter", {
            main = "nvim-treesitter.configs",
            opts = {
                additional_vim_regex_highlighting = false,
                ensure_installed = enabled_treesitter_filetypes,
                highlight = {
                    enabled = true,
                },
                indent = {
                    enabled = true,
                },
                sync_install = true,
            }
        }))

        table.insert(lazy_specs, PLUG("WhoIsSethDaniel/mason-tool-installer.nvim", {
            cmd = {
                "MasonToolsInstallSync",
                "MasonToolsUpdateSync",
                "MasonToolsClean"
            },
            dependencies = {
                PLUG("mason-org/mason.nvim", {
                    cmd = "Mason",
                    dependencies = {
                        PLUG("mason-org/mason-lspconfig.nvim", {
                            opts = { automatic_enable = false },
                        })
                    },
                    opts = {
                        max_concurrent_installers = 1,
                        ui = {
                            border = "rounded",
                            height = 0.95,
                            icons = {
                                package_installed = "✓",
                                package_pending = "➜",
                                package_uninstalled = "✗",
                            },
                            width = 0.95
                        },
                    }
                }),
            },
            opts = {
                auto_update = false,
                run_on_start = false,
                start_delay = 5000,
                debounce_hours = 24,
                ensure_installed = enabled_tools,
            }
        }))

        table.insert(lazy_specs, PLUG(
            "neovim/nvim-lspconfig", {
                ft = enabled_lsp_filetypes,
                config = function()
                    for lsp_name, lsp_opts in pairs(enabled_lsps) do
                        vim.lsp.enable(lsp_name)
                        vim.lsp.config(lsp_name, lsp_opts)
                    end
                end,
            }))

        return lazy_specs
    end
}
