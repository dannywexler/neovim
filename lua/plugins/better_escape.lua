return PLUG("max397574/better-escape.nvim", {
    event = "InsertEnter",
    opts = {
        default_mappings = false,
        mappings = {
            i = {
                j = {
                    k = "<Esc><Right>"
                }
            },
            t = {
                j = {
                    k = "<C-\\><C-n>",
                },
            },
        }
    }
})
