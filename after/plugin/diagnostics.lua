vim.diagnostic.config {
    float = {
        border = "rounded",
        focusable = false,
        header = "",
        prefix = "",
        source = false,
        style = "minimal",
    },
    signs = false,
    severity_sort = true,
    update_in_insert = false,
    underline = true,
    virtual_text = false,
    -- virtual_text = {
    --     prefix = '●',
    --     source = false,
    -- },
}

require('customPlugins.sleekerrors').setup()
