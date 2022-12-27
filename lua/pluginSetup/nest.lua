local leap = require 'leap'
local nest = require 'nest'

local function nmap(left, right)
    vim.keymap.set('n', left, right)
end

local lsp = vim.lsp.buf
local diag = vim.diagnostic
local telescope = require 'telescope.builtin'

vim.g.mapleader = ' '

local function get_line_starts(winid, searchAbove)
    local wininfo = vim.fn.getwininfo(winid)[1]
    local cur_line = vim.fn.line('.')
    local startLine = cur_line
    local endLine = wininfo.botline
    if searchAbove then
        endLine = startLine
        startLine = wininfo.topline
    end

    -- Get targets.
    local targets = {}
    local lnum = startLine
    while lnum <= endLine do
        local fold_end = vim.fn.foldclosedend(lnum)
        -- Skip folded ranges.
        if fold_end ~= -1 then
            lnum = fold_end + 1
        else
            if lnum ~= cur_line then table.insert(targets, { pos = { lnum, 1 } }) end
            lnum = lnum + 1
        end
    end
    -- Sort them by vertical screen distance from cursor.
    local cur_screen_row = vim.fn.screenpos(winid, cur_line, 1)['row']
    local function screen_rows_from_cur(t)
        local t_screen_row = vim.fn.screenpos(winid, t.pos[1], t.pos[2])['row']
        return math.abs(cur_screen_row - t_screen_row)
    end

    table.sort(targets, function(t1, t2)
        return screen_rows_from_cur(t1) < screen_rows_from_cur(t2)
    end)

    if #targets >= 1 then
        return targets
    end
end

-- Usage:
local function leap_to_line(searchAbove)
    local winid = vim.api.nvim_get_current_win()
    leap.leap {
        target_windows = { winid },
        targets = get_line_starts(winid, searchAbove),
    }
end

nmap('<leader>h', ':%s@<c-r>=expand("<cword>")<cr>@@gc<Left><Left><Left>')

nest.applyKeymaps {
    { mode = 'n', {
        { 'g', {
            { 'a', '<cmd>CodeActionMenu<CR>' },
            { 'd', lsp.definition },
            { 'f', diag.open_float },
            { 'h', lsp.hover },
            { 'n', lsp.rename },
            { 'r', telescope.lsp_references },
            { 's', lsp.signature_help },
        } },
        { 'j', function() leap.leap {} end },
        { 'J', '20<Down>' },
        { 'k', function() leap.leap { backward = true } end },
        { 'K', '20<Up>' },
        { 'q', {
            { 'e', ':tabclose<CR>' },
            { 'f', ':bp | bd #<CR>' },
            -- { 'f', ':BufferClose<CR>' },
            { 'q', ':qa!<CR>' },
            { 'w', 'ZZ' },
        } },
        { 's', '<NOP>' },

        { 's', {
            { 'a', telescope.live_grep },
            { 'A', telescope.grep_string },
            { 'd', telescope.find_files },
            { 'f', telescope.lsp_document_symbols },
            -- {'g', spectre.open_visual({select_word=true})},
            { 's', function()
                leap.leap { target_windows = require('leap.util').get_enterable_windows() }
            end }
        } },
        { 'U', '<C-r>' },
        { 'z', {
            { 'h', ':noh<CR>' },
        } },

        { '<Space>', '<NOP>' },
        { '>', 'V><Esc>' },
        { '<', 'V<<Esc>' },
        { '<Up>', 'gk' },
        { '<Down>', 'gj' },

        { '<A-', {
            { 'a>', '<C-w>h' },
            { 'A>', '<cmd>WinShift left<CR>' },
            -- { 'a>', ':DiffviewFileHistory %<CR>' },
            -- { 'A>', ':DiffviewFileHistory<CR>' },
            -- { 'c>', 'Vgc^', options = { noremap = false } },
            { 'd>', '<C-w>l' },
            { 'D>', '<cmd>WinShift right<CR>' },
            -- { 'e>', '<cmd>BufferPrev<CR>' },
            { 'e>', '<cmd>BufferLineCyclePrev<CR>' },
            -- { 'E>', '<cmd>BufferMovePrev<CR>' },
            { 'E>', '<cmd>BufferLineMovePrev<CR>' },
            -- { 'f>', '<cmd>BufferPick<CR>' },
            { 'f>', '<cmd>BufferLinePick<CR>' },
            { 'g>', ':DiffviewOpen<CR>' },
            { 'i>', '2<C-w><' },
            { 'j>', '2<Down>/function<CR>:noh<CR><Down>^zt' },
            { 'k>', '2<Up>?function<CR>:noh<CR><Down>^zt' },
            { 'm>', ':tabprevious<CR>' },
            { 'M>', ':-tabmove<CR>' },
            { 'n>', ':tabnext<CR>' },
            { 'N>', ':+tabmove<CR>' },
            { 'o>', '2<C-w>+' },
            { 'p>', '2<C-w>-' },
            -- { 'r>', '<cmd>BufferNext<CR>' },
            { 'r>', '<cmd>BufferLineCycleNext<CR>' },
            -- { 'R>', '<cmd>BufferMoveNext<CR>' },
            { 'R>', '<cmd>BufferLineMoveNext<CR>' },
            { 's>', '<C-w>j' },
            { 'S>', '<cmd>WinShift down<CR>' },
            { 'q>', '<C-w>k' },
            { 'Q>', '<cmd>WinShift up<CR>' },
            { 't>', ':lua require("FTerm").toggle()<CR>' },
            { 'u>', '2<C-w>>' },
            { 'v>', ':vsp<CR>' },
            { 'V>', ':sp<CR>' },
            { 'w>', '<C-w>k' },
            { 'W>', '<cmd>WinShift up<CR>' },
            { 'y>', '<C-w>=' },

            { '1>', '<cmd>BufferLineGoToBuffer 1<CR>' },
            { '2>', '<cmd>BufferLineGoToBuffer 2<CR>' },
            { '3>', '<cmd>BufferLineGoToBuffer 3<CR>' },
            { '4>', '<cmd>BufferLineGoToBuffer 4<CR>' },
            { '5>', '<cmd>BufferLineGoToBuffer 5<CR>' },
            { '6>', '<cmd>BufferLineGoToBuffer 6<CR>' },
            { '7>', '<cmd>BufferLineGoToBuffer 7<CR>' },
            { '8>', '<cmd>BufferLineGoToBuffer 8<CR>' },
            { '9>', '<cmd>BufferLineGoToBuffer 9<CR>' },

            -- { '1>', '<cmd>BufferGoto 1<CR>' },
            -- { '2>', '<cmd>BufferGoto 2<CR>' },
            -- { '3>', '<cmd>BufferGoto 3<CR>' },
            -- { '4>', '<cmd>BufferGoto 4<CR>' },
            -- { '5>', '<cmd>BufferGoto 5<CR>' },
            -- { '6>', '<cmd>BufferGoto 7<CR>' },
            -- { '7>', '<cmd>BufferGoto 8<CR>' },
            -- { '8>', '<cmd>BufferGoto 9<CR>' },
        } },

        { '<C-', {
            { 'j>', ':m .+1<CR>==' },
            { 'k>', ':m .-2<CR>==' },
            { 'r>', ':hello' },
        } },

        { '<leader>', {
            { 'e', ':NvimTreeToggle<CR>' },
            { 'f', lsp.format },
            -- h: replace word under cursor
            -- { 'o', ':AerialToggle<CR>' },
            { 'o', ':SymbolsOutline<CR>' },
        } },
    } },

    { mode = 'i', {
        { 'jk', '<Esc>`^' },
        { '<Up>', '<Esc>g<Up>a' },
        { '<Down>', '<Esc>g<Down>a' },
        { '<C-', {
            -- { 'i>', '<Backspace><Backspace><Backspace><Backspace><Backspace>' },
            -- { 'o>', '&emsp;' },
            { 'j>', '<Esc>:m .+1<CR>==gi' },
            { 'k>', '<Esc>:m .-2<CR>==gi' },
            { 'v>', '<Esc>p' },
        } }
    } },

    { mode = 'v', {
        { 'g', {
            { 's', ':sort<CR>' },
        } },
        -- { 'j', '<cmd>HopLineStartAC<cr>' },
        { 'j', function() leap_to_line(false) end },
        { 'J', '12<Down>' },
        -- { 'k', '<cmd>HopLineStartBC<cr>' },
        { 'k', function() leap_to_line(true) end },
        { 'K', '12<Up>' },

        { '<Space', '<Nop>' },
        { '>', '>gv' },
        { '<', '<gv' },

        { '<A-', {
            { 'c>', 'gc^', options = { noremap = false } },
        } },

        { '<C-', {
            { 'j>', ":m '>+1<CR>gv=gv" },
            { 'k>', ":m '<-2<CR>gv=gv" },
        } }
    } },

    { mode = 't', {
        { '<A-', {
            { 't>', '<C-\\><C-n>:lua require("FTerm").toggle()<CR>' },
        } }
    } }
}
