return PLUG("folke/snacks.nvim", {
    opts = {
        input = {},
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
            sources = {
                files = {
                    hidden = true,
                },
                smart = {
                    multi = {
                        -- "buffers",
                        "files",
                    },
                }
            },
            win = {
                input = {
                    keys = {
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                        ["<Tab>"] = { "edit_vsplit", mode = { "i", "n" } },
                    }
                },
                preview = {
                    wo = {
                        number = false
                    }
                }
            }
        },
        styles = {
            input = {
                keys = {
                    i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
                },
                relative = "cursor",
            }
        }
    }
})
