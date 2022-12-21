print('hello from tokyonight')
require 'tokyonight'.setup({
    styles = {
        comments = { italic = false },
        keywords = { italic = false, bold = true },
    }
})

vim.cmd [[colorscheme tokyonight]]
