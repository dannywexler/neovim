require 'colorful-winsep'.setup {
    highlight = {
        bg = "#000000",
        fg = "#00ffcc",
    },
    interval = WINDOWS and 200 or 30,
    -- This plugin will not be activated for filetype in the following table.
    no_exec_files = {
        -- 'aerial',
        "packer",
        "TelescopePrompt",
        "mason",
        "CompetiTest",
        "NvimTree",
    },
}
