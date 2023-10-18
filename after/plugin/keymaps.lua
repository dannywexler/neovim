local sleekeymap = require("customPlugins.sleekeymap")
local kmset = sleekeymap.set
local c = sleekeymap.cmd

local tele = setmetatable({}, {
    __index = function(_, name)
        return function()
            require('telescope.builtin')[name]()
        end
    end
})

kmset {
    n = {
        q = {
            q = c 'qa!',
            r = c 'cq2',
        },
        s = {
            d = tele.find_files
        },
        ctrl = {
            v = c 'vsplit',
            b = c 'split',
        }
    }
}
