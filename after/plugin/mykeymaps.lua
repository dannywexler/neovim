local km = require("sleekeymap")

local set = km.set
local h = km.helpers
local c = km.cmd

set({
    n = {
        q = {
            r = c("cq2"),
            q = c("qa!"),
        },
        leader = {
            b = h.win.split.horizontal,
            v = h.win.split.vertical
        }
    }
})
