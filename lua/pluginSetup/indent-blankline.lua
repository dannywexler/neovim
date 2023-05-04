local bar = '▏'
-- local bar = '▎'
require'indent_blankline'.setup {
    char = bar,
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
    context_char = bar,
    show_current_context = true,
    show_current_context_start = true,
    show_first_indent_level = false,
}
