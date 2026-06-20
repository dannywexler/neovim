local c = require("my.colors")
return PLUG("echasnovski/mini.base16", {
    opts = {
        palette = {
            base00 = c.greyDark,
            base01 = c.greyDark,
            base02 = c.blueDark,
            base03 = c.greyLight,
            base04 = c.greyDark,
            base05 = c.white,
            base06 = c.white,
            base07 = c.greyLight,
            base08 = c.red,
            base09 = c.orange,
            base0A = c.teal,
            base0B = c.greenLight,
            base0C = c.cyan,
            base0D = c.blueMedium,
            base0E = c.purple,
            base0F = c.greyLight,
        }
    },
    main = "mini.base16",
    priority = 1000,
})
