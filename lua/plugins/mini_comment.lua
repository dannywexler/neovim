return PLUG("echasnovski/mini.comment", {
    keys = { "m" },
    main = "mini.comment",
    opts = {
        mappings = {
            -- Toggle comment (like `gcip` - comment inner paragraph) for both
            -- Normal and Visual modes
            comment = "m",

            -- Toggle comment on current line
            comment_line = "m",

            -- Toggle comment on visual selection
            comment_visual = "m",

            -- Define 'comment' textobject (like `dgc` - delete whole comment block)
            -- Works also in Visual mode if mapping differs from `comment_visual`
            textobject = "m",
        }
    }
})
