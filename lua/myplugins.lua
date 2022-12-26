-- print('hello from myplugins')

local plugins = {}

local function p(name, url, extraOpts)
    local opts = {
        url,
        name = name,
        config = function()
            local ok, plug = pcall(require, 'pluginSetup.' .. name)
            if not ok then
                print('could not require ' .. name)
                -- else
                --     print('successfully required ' .. name)
            end
        end
    }
    for k, v in pairs(extraOpts or {}) do opts[k] = v end
    table.insert(plugins, opts)
end

p('cmp', 'hrsh7th/nvim-cmp')
p('cmp-buffer', 'hrsh7th/cmp-buffer')
p('cmp-cmdline', 'hrsh7th/cmp-cmdline')
p('cmp-luasnip', 'saadparwaiz1/cmp_luasnip')
p('cmp-nvim-lsp', 'hrsh7th/cmp-nvim-lsp')
p('cmp-nvim-lua', 'hrsh7th/cmp-nvim-lua')
p('cmp-path', 'hrsh7th/cmp-path')
p('import', 'miversen33/import.nvim')
p('leap', 'ggandor/leap.nvim')
p('lsp-zero', 'VonHeikemen/lsp-zero.nvim')
p('lspconfig', 'neovim/nvim-lspconfig')
p('luasnip', 'L3MON4D3/LuaSnip')
p('mason', 'williamboman/mason.nvim')
p('mason-lspconfig', 'williamboman/mason-lspconfig.nvim')
p('neodev', 'folke/neodev.nvim')
p('nest', 'LionC/nest.nvim')
p('plenary', 'nvim-lua/plenary.nvim')
p('telescope', 'nvim-telescope/telescope.nvim')
p('tokyonight', 'folke/tokyonight.nvim')
p('winshift', 'sindrets/winshift.nvim')

return plugins
