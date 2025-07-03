local icons = require("my.icons")
return PLUG("hasansujon786/nvim-navbuddy", {
    dependencies = { "navic" },
    event = "LspAttach",
    opts = {
        icons = require("my.icons").lsp,
        lsp = {
            auto_attach = true
        },
        node_markers = {
            enabled = true,
            icons = {
                leaf = " ",
                leaf_selected = " ",
                branch = icons.misc.greater .. " ",
            },
        },
        source_buffer = {
            follow_node = false, -- Keep the current node in focus on the source buffer
            highlight = false,   -- Highlight the currently focused node
            reorient = "none",   -- "smart", "top", "mid" or "none"
            scrolloff = nil      -- scrolloff value when navbuddy is open
        },
        window = {
            border = "rounded", -- "rounded", "double", "solid", "none"
            size = "60%",       -- Or table format example: { height = "40%", width = "100%"}
            position = "50%",   -- Or table format example: { row = "100%", col = "0%"}
            scrolloff = nil,    -- scrolloff value within navbuddy window
            sections = {
                left = {
                    size = "20%",
                    -- border = nil, -- You can set border style for each section individually as well.
                },
                mid = {
                    size = "40%",
                    -- border = nil,
                },
                right = {
                    -- No size option for right most section. It fills to
                    -- remaining area.
                    -- border = nil,
                    preview = "leaf", -- Right section can show previews too.
                    -- Options: "leaf", "always" or "never"
                }
            },
        },
    }
})
