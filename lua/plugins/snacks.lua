local terminal_style = {
    backdrop = false,
    border = "bold",
    height = 0.99,
    position = "float",
    width = 0,
}
return PLUG("folke/snacks.nvim", {
    ---@type snacks.Config
    opts = {
        input = {},
        notifier = {
            top_down = false
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
                    },
                    wo = {
                        cursorline = false,
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
                wo = {
                    cursorline = false,
                }
            },
            notification = {
                border = "bold"
            },
            lazygit = terminal_style,
            terminal = terminal_style,
        }
    }
})
