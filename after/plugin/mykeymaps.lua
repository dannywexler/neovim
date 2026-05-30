local km = require("sleekeymap")

local set = km.set
local h = km.helpers
local c = km.cmd

local function gotoWindow(windowNumber)
    return tostring(windowNumber) .. "<C-w>w"
end

---@enum (key) HopTo
local hopto_map = {
    w = "forward_start",
    e = "forward_end",
    b = "backward_end",
}

---@param action HopTo
local function hop(action)
    return function()
        local matching_action = hopto_map[action]
        local words = require("neowords")
        local hopper = words.get_word_hops(words.pattern_presets.any_word)
        hopper[matching_action]()
    end
end

---@enum (key) SnackPicker
local all_snack_pickers = {
    buffers = "buffers",
    diagnostics_buffer = "diagnostics_buffer",
    files = "files",
    git_status = "git_status",
    grep = "grep",
    grep_word = "grep_word",
    help = "highlights",
    highlights = "highlights",
    lsp_definitions = "lsp_definitions",
    lsp_references = "lsp_references",
    lsp_symbols = "lsp_symbols",
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

local function toggle_lazygit()
    require("snacks").terminal.toggle("lazygit")
end

set({
    n = {
        b = hop("b"),
        e = hop("e"),
        g = {
            a = function() vim.lsp.buf.code_action() end,
            d = snack("lsp_definitions"),
            p = c("Lspsaga peek_definition"),
            r = snack("lsp_references"),
            R = c("Lspsaga finder"),
            s = function()
                vim.cmd.vsplit()
                vim.lsp.buf.definition()
                vim.wait(50)
                vim.cmd.norm("zt")
            end,
            h = function() vim.lsp.buf.hover() end,
            n = function() vim.lsp.buf.rename() end,
        },
        h = scroll("up"),
        j = {
            d = c("Lspsaga diagnostic_jump_next"),
        },
        k = {
            d = c("Lspsaga diagnostic_jump_prev"),
        },
        l = scroll("down"),
        n = "nzz",
        N = "Nzz",
        p = "P",
        P = '"+P',
        q = {
            q = c("qa!"),
            r = c("cq2"),
            w = "ZZ",
        },
        s = {
            a = snack("grep"),
            b = snack("buffers"),
            d = snack("smart"),
            e = snack("diagnostics_buffer"),
            f = snack("lsp_symbols"),
            h = {
                f = snack("help"),
                l = snack("highlights"),
            },
            s = function() require("sleekfiles").refresh() end,
            w = snack("grep_word"),
        },
        U = "<C-r>",
        v = "V",
        V = "v",
        w = hop("w"),
        Esc = function()
            vim.fn.setreg("/", "wxyz")
            vim.cmd("nohlsearch")
        end,
        Up = "gk",
        Down = "gj",
        control = {
            g = toggle_lazygit,
            h = h.normal.line.shift.h,
            j = h.normal.line.shift.j,
            k = h.normal.line.shift.k,
            l = h.normal.line.shift.l,
            t = function() require("snacks").terminal() end,
        },
        leader = {
            a = gotoWindow(1),
            b = h.win.split.horizontal,
            d = gotoWindow(3),
            e = c("Neotree"),
            f = gotoWindow(4),
            n = c("Navbuddy"),
            g = gotoWindow(5),
            m = function() require("utils.log").toggle() end,
            p = function() require("utils.format")() end,
            r = ":%s@<C-r><C-w>@@gc<Left><Left><Left>",
            s = gotoWindow(2),
            v = h.win.split.vertical,
            y = '"+y',
            w = c("Neotree reveal"),
        }
    },
    t = {
        control = {
            g = toggle_lazygit,
            t = function() require("snacks").terminal() end,
        },
        Esc = "<C-\\><C-n>",
    },
    v = {
        p = "P",
        s = ":'<,'>sort<CR>",
        control = {
            h = h.visual.line.shift.h,
            j = h.visual.line.shift.j,
            k = h.visual.line.shift.k,
            l = h.visual.line.shift.l,
            t = function() require("snacks").terminal() end,
        },
        leader = {
            y = '"+y',
        }
    }
})
