local km = require("sleekeymap")

local set = km.set
local h = km.helpers
local c = km.cmd

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
            r = c("cq2"),
            q = c("qa!"),
        },
        s = {
            a = snack("grep"),
            b = snack("buffers"),
            d = snack("files"),
            w = snack("grep_word"),
        },
        leader = {
            b = h.win.split.horizontal,
            c = snack("git_status"),
            e = function() require("snacks").explorer.open() end,
            v = h.win.split.vertical,
            w = function() require("snacks").explorer.reveal() end,
        }
    }
})
