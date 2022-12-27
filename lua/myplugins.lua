local plugins = {}

local function getConfig(name)
    if name == 'scope' then
        require 'scope'.setup()
        return
    end
    local path = vim.fn.stdpath('config') .. '/lua/pluginSetup/' .. name .. '.lua'
    if vim.fn.filereadable(path) == 1 then
        require('pluginSetup.' .. name)
    end
end

local function p(name, url, extraOpts)
    local opts = {
        url,
        name = name,
        config = function()
            getConfig(name)
        end
    }
    for k, v in pairs(extraOpts or {}) do opts[k] = v end
    table.insert(plugins, opts)
end

p('autopairs', 'windwp/nvim-autopairs')
p('autotag', 'windwp/nvim-ts-autotag')
p('bufferline', 'akinsho/bufferline.nvim')
p('cmp', 'hrsh7th/nvim-cmp')
p('cmp-buffer', 'hrsh7th/cmp-buffer')
p('cmp-cmdline', 'hrsh7th/cmp-cmdline')
p('cmp-luasnip', 'saadparwaiz1/cmp_luasnip')
p('cmp-nvim-lsp', 'hrsh7th/cmp-nvim-lsp')
p('cmp-nvim-lua', 'hrsh7th/cmp-nvim-lua')
p('cmp-path', 'hrsh7th/cmp-path')
p('colorizer', 'NvChad/nvim-colorizer.lua')
p('comment', 'numToStr/Comment.nvim')
p('comment-context', 'JoosepAlviste/nvim-ts-context-commentstring')
p('diffview', 'sindrets/diffview.nvim')
p('dressing', 'stevearc/dressing.nvim')
p('fterm', 'numToStr/FTerm.nvim')
p('hlargs', 'm-demare/hlargs.nvim')
p('indent-blankline', 'lukas-reineke/indent-blankline.nvim')
p('leap', 'ggandor/leap.nvim')
p('lsp-zero', 'VonHeikemen/lsp-zero.nvim')
p('lspconfig', 'neovim/nvim-lspconfig')
p('lualine', 'nvim-lualine/lualine.nvim')
p('luasnip', 'L3MON4D3/LuaSnip')
p('mason', 'williamboman/mason.nvim')
p('mason-lspconfig', 'williamboman/mason-lspconfig.nvim')
p('neodev', 'folke/neodev.nvim')
p('nest', 'LionC/nest.nvim')
p('nvimtree', 'kyazdani42/nvim-tree.lua')
p('persisted', 'olimorris/persisted.nvim')
p('plenary', 'nvim-lua/plenary.nvim')
p('scope', 'tiagovla/scope.nvim')
p('scrollview', 'dstein64/nvim-scrollview')
p('telescope', 'nvim-telescope/telescope.nvim')
p('telescope-zf-native', 'natecraddock/telescope-zf-native.nvim')
p('tokyonight', 'folke/tokyonight.nvim')
p('treesitter', 'nvim-treesitter/nvim-treesitter', { build = WINDOWS and ':TSUpdateSync' or ':TSUpdate' })
p('treesitter-playground', 'nvim-treesitter/playground')
p('treesitter-rainbow', 'p00f/nvim-ts-rainbow')
p('treesitter-textobjects', 'nvim-treesitter/nvim-treesitter-textobjects')
p('treesj', 'Wansmer/treesj')
p('web-devicons', 'kyazdani42/nvim-web-devicons')
p('winshift', 'sindrets/winshift.nvim')

return plugins

--[[
Possible plugins to add:
    aerial
    code action menu
    dial or equivalent
    pretty fold (or ufo fold)
    noice
    sort
    symbols-outline
    various textobjects
--]]
