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

-- p('autosession', 'rmagatti/auto-session')
-- p('code-action-menu', 'weilbith/nvim-code-action-menu')
-- p('fterm', 'numToStr/FTerm.nvim')
-- p('noice', 'folke/noice.nvim')
-- p('pretty-fold', 'anuvyklack/pretty-fold.nvim')
-- p('searchbox', 'VonHeikemen/searchbox.nvim')
-- p('aerial', 'stevearc/aerial.nvim')
p('autopairs', 'windwp/nvim-autopairs')
p('autotag', 'windwp/nvim-ts-autotag')
p('better-escape', 'max397574/better-escape.nvim')
p('boole', 'nat-418/boole.nvim')
p('bufferline', 'akinsho/bufferline.nvim')
p('cmp', 'hrsh7th/nvim-cmp', { event = 'InsertEnter' })
p('cmp-buffer', 'hrsh7th/cmp-buffer')
p('cmp-cmdline', 'hrsh7th/cmp-cmdline')
p('cmp-luasnip', 'saadparwaiz1/cmp_luasnip')
p('cmp-nvim-lsp', 'hrsh7th/cmp-nvim-lsp')
p('cmp-nvim-lua', 'hrsh7th/cmp-nvim-lua')
p('cmp-path', 'hrsh7th/cmp-path')
-- p('colorful-winseparator', 'nvim-zh/colorful-winsep.nvim')
p('colorizer', 'NvChad/nvim-colorizer.lua')
p('comment', 'numToStr/Comment.nvim')
p('comment-context', 'JoosepAlviste/nvim-ts-context-commentstring')
p('diffview', 'sindrets/diffview.nvim', { cmd = 'DiffviewOpen' })
p('dressing', 'stevearc/dressing.nvim')
-- p('hlargs', 'm-demare/hlargs.nvim')
p('indent-blankline', 'lukas-reineke/indent-blankline.nvim')
p('indent-tools', 'arsham/indent-tools.nvim')
p('indent-tools-helper', 'arsham/arshlib.nvim')
p('indentwise', 'jeetsukumaran/vim-indentwise')
p('leap', 'ggandor/leap.nvim')
p('lsp-signature', 'ray-x/lsp_signature.nvim')
p('lsp-zero', 'VonHeikemen/lsp-zero.nvim')
p('lspconfig', 'neovim/nvim-lspconfig')
p('lspkind', 'onsails/lspkind.nvim')
p('lspsaga', 'glepnir/lspsaga.nvim')
-- p('lualine', 'nvim-lualine/lualine.nvim')
p('luasnip', 'L3MON4D3/LuaSnip')
p('mason', 'williamboman/mason.nvim')
p('mason-lspconfig', 'williamboman/mason-lspconfig.nvim')
p('navic', 'SmiteshP/nvim-navic')
p('neodev', 'folke/neodev.nvim', {ft = 'lua'})
p('nest', 'LionC/nest.nvim')
p('nui', 'MunifTanjim/nui.nvim')
p('nvim-jdtls', 'mfussenegger/nvim-jdtls')
p('nvimtree', 'kyazdani42/nvim-tree.lua', { cmd = { 'NvimTreeToggle', 'NvimTreeFindFile', 'NvimTreeClose' } })
p('plenary', 'nvim-lua/plenary.nvim')
p('promise-async', 'kevinhwang91/promise-async')
p('schemastore', 'b0o/schemastore.nvim')
p('scope', 'tiagovla/scope.nvim')
-- p('scrollview', 'dstein64/nvim-scrollview')
p('session-manager', 'Shatur/neovim-session-manager')
p('sort', 'sQVe/sort.nvim')
p('telescope', 'nvim-telescope/telescope.nvim')
p('telescope-zf-native', 'natecraddock/telescope-zf-native.nvim')
p('toggleterm', 'akinsho/toggleterm.nvim')
p('tokyonight', 'folke/tokyonight.nvim')
p('treesitter', 'nvim-treesitter/nvim-treesitter', { build = WINDOWS and ':TSUpdateSync' or ':TSUpdate' })
p('treesitter-playground', 'nvim-treesitter/playground', { cmd = 'TSPlaygroundToggle' })
-- p('treesitter-rainbow', 'p00f/nvim-ts-rainbow')
p('treesitter-textobjects', 'nvim-treesitter/nvim-treesitter-textobjects')
p('treesj', 'Wansmer/treesj', { cmd = 'TSJToggle' })
p('ufo', 'kevinhwang91/nvim-ufo')
p('web-devicons', 'kyazdani42/nvim-web-devicons')
p('winshift', 'sindrets/winshift.nvim')
p('windline', 'windwp/windline.nvim')

table.insert(plugins, {
    'https://gitlab.com/yorickpeterse/nvim-dd.git',
    name = 'defer-diagnostics',
    url = 'https://gitlab.com/yorickpeterse/nvim-dd.git',
    config = function()
        require 'dd'.setup {
            timeout = 800
        }
    end
})

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
