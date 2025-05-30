local km = require("sleekeymap")

local set = km.set
local h = km.helpers
local c = km.cmd

local function gotoWindow(windowNumber)
    return tostring(windowNumber) .. "<C-w>w"
end

---@enum (key) SnackPicker
local all_snack_pickers = {
    buffers = "buffers",
    files = "files",
    git_status = "git_status",
    grep = "grep",
    grep_word = "grep_word",
    help = "highlights",
    highlights = "highlights",
    smart = "smart"
}

---@param picker SnackPicker
local function snack(picker)
    return function() require("snacks").picker[picker]() end
end

---@param direction "up" | "down"
local function scroll(direction)
    local opts = { duration = 100 }
    if (direction == "up") then
        return function() require("neoscroll").ctrl_u(opts) end
    else
        return function() require("neoscroll").ctrl_d(opts) end
    end
end

set({
    n = {
        h = scroll("up"),
        l = scroll("down"),
        m = "gcc",
        n = "nzz",
        N = "Nzz",
        q = {
            q = c("qa!"),
            r = c("cq2"),
            w = "ZZ",
        },
        s = {
            a = snack("grep"),
            b = snack("buffers"),
            d = snack("smart"),
            h = {
                f = snack("help"),
                l = snack("highlights"),
            },
            w = snack("grep_word"),
        },
        v = "V",
        V = "v",
        control = {
            h = h.normal.line.shift.h,
            j = h.normal.line.shift.j,
            k = h.normal.line.shift.k,
            l = h.normal.line.shift.l,
        },
        leader = {
            a = gotoWindow(1),
            b = h.win.split.horizontal,
            c = snack("git_status"),
            d = gotoWindow(3),
            e = c("Neotree"),
            f = gotoWindow(4),
            g = gotoWindow(5),
            r = ":%s@<C-r><C-w>@@gc<Left><Left><Left>",
            s = gotoWindow(2),
            v = h.win.split.vertical,
            w = c("Neotree reveal"),
        }
    },
    v = {
        m = "gc",
        control = {
            h = h.visual.line.shift.h,
            j = h.visual.line.shift.j,
            k = h.visual.line.shift.k,
            l = h.visual.line.shift.l,
        }
    }
})
