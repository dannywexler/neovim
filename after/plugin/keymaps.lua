local sleekeymap = require("customPlugins.sleekeymap")
local kmset = sleekeymap.set
local c = sleekeymap.cmd
kmset {
    n = {
        q = {
            q = c 'qa!',
            r = c 'cq2',
        },
        ctrl = {
            v = c 'vsplit',
            b = c 'split',
        }
    }
}
