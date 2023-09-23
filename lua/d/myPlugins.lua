---@type { [string]: LazySpec }
return {
    onedark = {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            local onedark = require("onedark")
            onedark.setup {
                style = "deep"
            }
            onedark.load()
        end

    }
}
