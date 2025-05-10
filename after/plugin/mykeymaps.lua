local km = require("sleekeymap")

local set = km.set
local h = km.helpers
local c = km.cmd

local function gotoWindow(windowNumber)
    return tostring(windowNumber) .. "<C-w>w"
end

---@enum (key) SnackPicker
local all_snack_pickers = {
    buffers = {},
    files = { hidden = true },
    git_status = {},
    grep = {},
    grep_word = {},
}

---@param picker SnackPicker
local function snack(picker)
    local opts = all_snack_pickers[picker]
    return function() require("snacks").picker[picker](opts) end
end

set({
    n = {
        q = {
            q = c("qa!"),
            r = c("cq2"),
            w = "ZZ",
        },
        s = {
            a = snack("grep"),
            b = snack("buffers"),
            d = snack("files"),
            w = snack("grep_word"),
        },
        leader = {
            a = gotoWindow(1),
            b = h.win.split.horizontal,
            c = snack("git_status"),
            d = gotoWindow(3),
            e = function() require("snacks").explorer.open() end,
            f = gotoWindow(4),
            g = gotoWindow(5),
            s = gotoWindow(2),
            v = h.win.split.vertical,
            w = function() require("snacks").explorer.reveal() end,
        }
    }
})
