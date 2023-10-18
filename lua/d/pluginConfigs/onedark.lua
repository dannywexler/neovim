return {
    priority = 1000,
    lazy = false,
    config = function()
        local onedark = require('onedark')
        onedark.setup {
            style = 'deep'
        }
        onedark.load()
    end
}
