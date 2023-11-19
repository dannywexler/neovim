local sleekeymap = require("customPlugins.sleekeymap")
local kmset = sleekeymap.set
local c = sleekeymap.cmd

local vlsp = vim.lsp.buf
local diag = vim.diagnostic

local tele = setmetatable({}, {
    __index = function(_, name)
        return function()
            require('telescope.builtin')[name]()
        end
    end
})

local resize_amount = 4

local a = {
    lsp = {
        diagnostics = {
            next = function()
                diag.goto_next({ float = true })
            end,
            prev = function()
                diag.goto_prev({ float = true })
            end
        }
    },
    window = {
        resize = {
            equalize = c 'wincmd =',
            narrower = c(resize_amount .. 'wincmd <'),
            shorter = c(resize_amount .. 'wincmd -'),
            taller = c(resize_amount .. 'wincmd +'),
            wider = c(resize_amount .. 'wincmd >'),
        },
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
        g = {
            e = a.lsp.diagnostics.prev,
            f = a.lsp.diagnostics.next,
        },
        q = {
            f = c 'bp | bd #',
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
            i = a.window.resize.narrower,
            j = a.window.select.down,
            J = a.window.shift.down,
            k = a.window.select.up,
            K = a.window.shift.up,
            l = a.window.select.right,
            L = a.window.shift.right,
            o = a.window.resize.taller,
            p = a.window.resize.shorter,
            u = a.window.resize.wider,
            y = a.window.resize.equalize,
        },
        ctrl = {
            v = a.window.split.vertically,
            b = a.window.split.horizontally,
        },
        leader = {
            e = c 'Neotree toggle',
            E = c 'Neotree toggle reveal',
            r = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
        }
    }
}
