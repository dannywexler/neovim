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

local a = {
    window = {
        select = {
            down = c 'wincmd j',
            left = c 'wincmd h',
            right = c 'wincmd l',
            up = c 'wincmd k',
        },
        shift = {
            down = c 'WinShift down',
            left = c 'WinShift left',
            right = c 'WinShift right',
            up = c 'WinShift up',
        },
        split = {
            horizontally = c 'split',
            vertically = c 'vsplit',
        }
    }
}

kmset {
    n = {
        q = {
            q = c 'qa!',
            r = c 'cq2',
            w = 'ZZ',
        },
        s = {
            d = tele.find_files
        },
        alt = {
            h = a.window.select.left,
            H = a.window.shift.left,
            j = a.window.select.down,
            J = a.window.shift.down,
            k = a.window.select.up,
            K = a.window.shift.up,
            l = a.window.select.right,
            L = a.window.shift.right,
        },
        ctrl = {
            v = a.window.split.vertically,
            b = a.window.split.horizontally,
        },
        leader = {
            r = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
        }
    }
}
