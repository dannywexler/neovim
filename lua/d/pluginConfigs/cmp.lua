return {
    dependencies = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
    },
    event = { 'InsertEnter' },
    config = function()
        local cmp = require 'cmp'
        cmp.setup {
            mapping = cmp.mapping.preset.insert({
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
            }),
            snippet = {
                expand = function(args)
                    require 'luasnip'.lsp_expand(args.body)
                end,
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            },
            window = {
                completion = {
                    border = 'rounded',
                    col_offset = -1
                },
                documentation = cmp.config.window.bordered(),
            },
        }
    end
}
