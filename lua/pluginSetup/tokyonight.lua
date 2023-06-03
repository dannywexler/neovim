require 'tokyonight'.setup {
    on_colors = function (colors)
        colors.blue = '#0091f8'
        colors.blue0 = '#7aa2f7'
        colors.blue1 = colors.blue
        colors.blue2 = colors.blue1
        colors.blue3 = colors.blue1
        colors.blue4 = colors.blue1
        colors.blue5 = colors.blue1
        colors.blue6 = colors.blue1
        colors.blue7 = colors.blue1
        colors.border_highlight = colors.fg
        colors.comment = '#b8bdd1'
        colors.cyan = '#0db9d7'
        colors.dark3 = colors.comment
        colors.dark5 = colors.comment
        colors.fg = '#FFFFFF'
        -- colors.fg_dark = colors.fg
        colors.bg = '#12131b'
        colors.fg_float = colors.fg
        -- colors.fg_gutter = colors.fg
        colors.fg_sidebar = colors.fg
        colors.green = '#00fa9a'
        colors.green1 = '#1abc9c'
        colors.green2 = colors.green1
        colors.hint = colors.green1
        colors.info = colors.cyan
        colors.red = colors.cyan
        colors.red1 = colors.cyan
        colors.purple = '#c678dd'
        colors.magenta = colors.purple
    end,
    style = "night",
    styles = {
        comments = { italic = true },
        keywords = { italic = false, bold = true },
        functions = { bold = true}
    },
    terminal_colors = false,
}

vim.cmd.colorscheme('tokyonight')
