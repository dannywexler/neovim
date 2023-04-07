require 'tokyonight'.setup {
    style = "night",
    styles = {
        comments = { italic = false },
        keywords = { italic = false, bold = true },
    },
    terminal_colors = false,
}

vim.cmd.colorscheme('tokyonight')
