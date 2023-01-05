local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

require("luasnip.loaders.from_snipmate").lazy_load()
local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--   פּ ﯟ   some other good icons
local kind_icons = {
    Class = "",
    Color = "",
    Constant = "",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "",
    File = "",
    Folder = "",
    Function = "",
    Interface = "",
    Keyword = "",
    Method = "m",
    Module = "",
    Operator = "",
    Property = "",
    Reference = "",
    Snippet = "",
    Struct = "",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "",
    Variable = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup {
    -- completion = {
    --     keyword_length = 3
    -- },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    experimental = {
        ghost_text = false,
        native_menu = false,
    },
    formatting = {
        fields = { "abbr", "kind", "menu" },
        -- format = function(entry, vim_item)
        --     -- Kind icons
        --     -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        --     vim_item.kind = string.format('%s  %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        --     vim_item.menu = ({
        --         luasnip = "[Snippet]",
        --         nvim_lsp = "[LSP]",
        --         nvim_lua = '[NVIM]',
        --         path = "[Path]",
        --         buffer = "[Buffer]",
        --     })[entry.source.name]
        --     return vim_item
        -- end,
        format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
                vim_item.menu = ({
                    luasnip = "[Snippet]",
                    nvim_lsp = "[LSP]",
                    nvim_lua = '[NVIM]',
                    path = "[Path]",
                    buffer = "[Buffer]",
                })[entry.source.name]
                return vim_item
            end
        })
    },
    mapping = {
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        -- ["<C-e>"] = cmp.mapping {
        --   i = cmp.mapping.abort(),
        --   c = cmp.mapping.close(),
        -- },
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<M-l>"] = cmp.mapping(function(fallback)
            if luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<M-h>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
    },
    performance = {
        debounce = WINDOWS and 200 or 50,
        throttle = WINDOWS and 200 or 50,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    -- sorting = {
    --     comparators = {
    --         function(...) return require'cmp_buffer':compare_locality(...) end,
    --     }
    -- }
    sources = {
        { name = "luasnip" },
        { name = "nvim_lsp", max_item_count = 30 },
        { name = "nvim_lua", max_item_count = 30 },
        { name = "path" },
        { name = "buffer",
            option = {
                get_bufnrs = function()
                    local buf = vim.api.nvim_get_current_buf()
                    local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                    if byte_size > 1024 * 100 then -- 100K max
                        return {}
                    end

                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end,
                -- indexing_interval = 800,
                indexing_interval = 100,
                -- indexing_batch_size = 200,
                indexing_batch_size = 2000,
                keyword_length = 5
            },
            keyword_length = 5,
            max_item_count = 20,
        },
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        completion = {
            border = 'rounded',
            col_offset = -1
        },
        documentation = cmp.config.window.bordered(),
    },
}

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        {
            name = 'path',
            keyword_length = 1,
            max_item_count = 30,
        }
    }, {
        {
            name = 'cmdline',
            max_item_count = 30,
            keyword_length = 1,
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})
