local maxLines = 1000
require 'hlargs'.setup {
    color = '#C408C4',
    -- highlight = { fg = '#C408C4' },
    disable = function(lang, buf)
        return vim.api.nvim_buf_line_count(buf) > maxLines
        -- local max_filesize = 1024 * 100 -- 100 KB
        -- local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        -- if ok and stats and stats.size > max_filesize then
        --     return true
        -- end
        -- return false
    end,
    performance = {
        debounce = {
            partial_parse = 1000,
            partial_insert_mode = 1000,
            total_parse = 2000,
            slow_parse = 5000
        },
        max_concurrent_partial_parses = 50,
        max_iterations = 400,
        parse_delay = 10,
        slow_parse_delay = 200,
    }
}
