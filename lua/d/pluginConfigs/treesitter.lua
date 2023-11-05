local treesitter_langs = vim.tbl_keys(require('d.languages'))
return {
    build = LINUX and ':TSUpdate' or ':TSUpdateSync',
    ft = treesitter_langs,
    config = function()
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = treesitter_langs,
            highlight = { enable = true },
        }
    end
}
