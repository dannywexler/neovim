require 'hlargs'.setup {
    color = '#C408C4',
    -- highlight = { fg = '#C408C4' },
    performance = {
        debounce = {
            partial_parse = 400,
            partial_insert_mode = 1000
        },
        parse_delay = 10,
    }
}
