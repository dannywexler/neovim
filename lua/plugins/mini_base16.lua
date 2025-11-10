local c = require("my.colors")
return PLUG("echasnovski/mini.base16", {
    opts = {
        palette = {
            base00 = c.grey.dark,
            base01 = c.grey.dark,
            base02 = c.blue.dark,
            base03 = c.grey.light,
            base04 = c.grey.dark,
            base05 = c.white,
            base06 = c.white,
            base07 = c.grey.light,
            base08 = c.red,
            base09 = c.orange,
            base0A = c.teal,
            base0B = c.green.light,
            base0C = c.cyan,
            base0D = c.blue.medium,
            base0E = c.purple,
            base0F = c.grey.light,
        }
    },
    main = "mini.base16",
    priority = 1000,
})
