local lsp_icons = require('d.icons').lsp
local source_map = {
    buffer = "BUF",
    luasnip = "SNP",
    nvim_lsp = "LSP",
    path = "PAT",
}
local minCols = 50
local maxCols = 50
local maxRows = 10
local maxItems = 20
return {
    dependencies = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
    },
    event = { 'InsertEnter' },
    config = function()
        local cmp = require 'cmp'
        cmp.setup {
            formatting = {
                format = function(entry, vim_item)
                    vim_item.abbr = ('%-' .. minCols .. 's'):format(vim_item.abbr)
                    -- Kind icons
                    vim_item.kind = lsp_icons[vim_item.kind] .. vim_item.kind
                    -- Source
                    vim_item.menu = source_map[entry.source.name]
                    return vim_item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
            }),
            performance = {
                max_view_entries = maxRows
            },
            snippet = {
                expand = function(args)
                    require 'luasnip'.lsp_expand(args.body)
                end,
            },
            sources = {
                { name = 'luasnip' },
                {
                    name = 'nvim_lsp',
                    -- max_item_count = 20,
                },
                { name = 'buffer' },
                { name = 'path' },
            },
            window = {
                completion = {
                    border = 'rounded',
                    col_offset = -1,
                    scrollbar = true,
                },
                documentation = {
                    border = 'rounded',
                    max_width = maxCols,
                    max_height = maxRows,
                }
            },
        }

        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                {
                    name = 'path',
                    -- keyword_length = 1,
                    -- max_item_count = maxItems,
                }
            }, {
                {
                    name = 'cmdline',
                    max_item_count = maxItems,
                    -- keyword_length = 1,
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                }
            })
        })
    end
}
