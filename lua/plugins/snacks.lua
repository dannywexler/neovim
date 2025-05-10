return PLUG("folke/snacks.nvim", {
    lazy = true,
    opts = {
        explorer = {
            replace_netrw = true
        },
        picker = {
            formatters = {
                file = {
                    filename_first = true
                }
            },
            matcher = {
                frecency = true,
                history_bonus = true,
            },
            prompt = "  ",
            win = {
                input = {
                    keys = {
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                        ["<Tab>"] = { "edit_vsplit", mode = { "i", "n" } },
                    }
                }
            }
        }
    }
})
