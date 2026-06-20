vim.o.termguicolors = true

local maximal_options = {
    parsers = {
        names = { enable = true },
        rgb = { enable = true },
        hsl = { enable = true },
        oklch = { enable = true },
        css_color = { enable = true },
        tailwind = { enable = true, lsp = true },
    }
}

return PLUG("catgoose/nvim-colorizer.lua", {
    ft = {
        "css",
        "html",
        "javascript",
        "javascriptreact",
        "liquid",
        "lua",
        "sh",
        "typescript",
        "typescriptreact",
        "yaml",
    },
    opts = {
        lazy_Load = true,
        options = {
            display = {
                mode = "background",
                virtualtext = {
                    -- char = "  ",
                    char = "  ",
                    hl_mode = "background",
                }
            },
            filetypes = {
                css = maximal_options,
                sh = { parsers = { xterm = { enable = true } } }
            },
            parsers = {
                names = {
                    enable = false
                }
            }
        }
    }
})
