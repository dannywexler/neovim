local terminal_style = {
    backdrop = false,
    border = vim.o.winborder,
    height = 0.99,
    position = "float",
    width = 0,
}
return PLUG("folke/snacks.nvim", {
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
        input = {},
        notifier = {
            top_down = false,
            width = { min = 40, max = 0.7 },
        },
        picker = {
            formatters = {
                file = {
                    filename_first = true,
                    truncate = 240,
                },
            },
            layouts = {
                default = {
                    layout = {
                        box = "horizontal",
                        width = 0,
                        height = 0.99,
                        {
                            box = "vertical",
                            border = "rounded",
                            title = "{title} {live} {flags}",
                            {
                                win = "input",
                                height = 1,
                                border = "bottom"
                            },
                            {
                                win = "list",
                                border = "none"
                            },
                        },
                        { win = "preview", title = "{preview}", width = 80, border = "rounded" }
                    }
                },
                small = {
                    layout = {
                        box = "vertical",
                        width = 0.5,
                        height = 0.8,
                        {
                            box = "vertical",
                            border = "rounded",
                            title = "{title} {live} {flags}",
                            {
                                win = "input",
                                height = 1,
                                border = "bottom"
                            },
                            {
                                win = "list",
                                border = "none"
                            },
                        },
                    }
                }
            },
            matcher = {
                sort_empty = true,
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
                    layout = "small"
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
            -- notification = {
            --     -- border = "bold"
            -- },
            notification_history = {
                width = 0.95,
                height = 0.95,
            },
            lazygit = terminal_style,
            terminal = terminal_style,
        }
    }
})
