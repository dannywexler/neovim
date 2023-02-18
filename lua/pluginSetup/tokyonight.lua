require 'tokyonight'.setup {
    styles = {
        comments = { italic = false },
        keywords = { italic = false, bold = true },
    },
    terminal_colors = false,
}

vim.cmd.colorscheme('tokyonight')
