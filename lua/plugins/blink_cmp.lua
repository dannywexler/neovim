return PLUG("saghen/blink.cmp", {
    version = "1.*",
    opts = {
        appearance = {
            kind_icons = require("my.icons").lsp
        },
        completion = {
            documentation = { window = { border = "rounded" } },
            menu = {
                border = "rounded",
                draw = {
                    columns = {
                        { "label",     "label_description", gap = 1 },
                        { "kind_icon", "kind",              gap = 1, "source_name" }
                    },
                    components = {
                        label = {
                            width = {
                                min = 30,
                                max = 60,
                                fill = true,
                            }
                        }
                    }
                }
            }
        },
        keymap = { preset = "super-tab" },
        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
                buffer = {
                    name = "BUF",
                    min_keyword_length = 3,
                    max_items = 6
                },
                lazydev = {
                    name = "LZY",
                    module = "lazydev.integrations.blink",
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
            }
        }
    }
})
