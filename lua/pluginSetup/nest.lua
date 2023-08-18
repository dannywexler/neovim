local leap = require 'leap'
local nest = require 'nest'
-- local searchbox = require 'searchbox'
-- local tree = require 'tree-climber'
-- local treeopts = {
--     skip_comments = true,
--     highlight = true,
-- }

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

local function startBuild()
    -- vim.cmd('TermExec cmd="sleep 10 && date" open=0')
    vim.cmd('TermExec cmd="build" open=0')
end

local function watchTerm()
    vim.cmd('3TermExec cmd="tsx watch %" direction=vertical')
end

-- local function searchReplace()
--     searchbox.replace({
--         default_value = vim.fn.expand('<cword>')
--     })
-- end

nmap('<leader>r', ':%s@<c-r>=expand("<cword>")<cr>@@gc<Left><Left><Left>')

nest.applyKeymaps {
    {
        mode = 'n',
        {
            { 'g', {
                -- { 'a', lsp.code_action},
                -- { 'a', '<cmd>CodeActionMenu<CR>' },
                { 'a', '<cmd>Lspsaga code_action<CR>' },
                { 'd', lsp.definition },
                { 'e', function()
                    -- diag.goto_prev({float = true})
                    require("lspsaga.diagnostic"):goto_prev()
                end },
                { 'f', function()
                    -- diag.goto_next({float = true})
                    -- require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
                    require("lspsaga.diagnostic"):goto_next()
                end },
                -- { 'h', lsp.hover },
                { 'h', '<cmd>Lspsaga hover_doc ++quiet<CR>' },
                { 'n', lsp.rename },
                { 'r', telescope.lsp_references },
                { 's', lsp.signature_help },
            } },
            -- { 'H', function () tree.goto_parent(treeopts) end},
            { 'H', '<Plug>(IndentWisePreviousLesserIndent)',    options = { noremap = false } },
            { 'j', function() leap.leap {} end },
            -- { 'J', '20<Down>' },
            -- { 'J', function () tree.goto_next(treeopts) end},
            { 'J', '<Plug>(IndentWiseNextEqualIndent)',         options = { noremap = false } },
            { 'k', function() leap.leap { backward = true } end },
            -- { 'K', '20<Up>' },
            -- { 'K', function () tree.goto_prev(treeopts) end},
            { 'K', '<Plug>(IndentWisePreviousEqualIndent)',     options = { noremap = false } },
            -- { 'L', function () tree.goto_child(treeopts) end},
            { 'L', '<Plug>(IndentWiseNextGreaterIndent)',       options = { noremap = false } },
            { 'q', {
                { 'e', ':tabclose<CR>' },
                { 'f', ':bp | bd #<CR>' },
                -- { 'f', ':BufferClose<CR>' },
                -- { 'q', ':qa!<CR>' },
                { 'q', ':NvimTreeClose<CR>:qa!<CR>' },
                { 'w', 'ZZ' },
            } },
            { 's', '<NOP>' },

            { 's', {
                -- {'g', spectre.open_visual({select_word=true})},
                { "'", "vi':Sort ui<CR>" },
                { '"', 'vi":Sort ui<CR>' },
                { 'A', telescope.grep_string },
                { 'a', telescope.live_grep },
                { 'd', telescope.find_files },
                { 'e', '<cmd>Lspsaga show_buf_diagnostics<CR>' },
                { 'E', '<cmd>Lspsaga show_workspace_diagnostics<CR>' },
                { 'f', telescope.lsp_document_symbols },
                { 'h', telescope.highlights },
                { 'H', telescope.help_tags },
                -- { 'i', "vii:'<,'>Sort ui<CR>" },
                { 'p', 'Vip:Sort ui<CR>' },
                { 's', function() leap.leap { target_windows = require('leap.util').get_enterable_windows() } end },
                { '{', 'vi{:Sort ui<CR>' },
                { '[', 'vi[:Sort ui<CR>' },
                { '|', 'vi|:Sort ui<CR>' },
            } },
            { 'U', '<C-r>' },
            { "v", "V" },
            { "V", "v" },
            { 'z', {
                { 'h', function()
                    vim.fn.setreg('/', 'wxyz')
                    vim.cmd('noh')
                end },
            } },

            { '<Space>',  '<NOP>' },
            { '>',        'V><Esc>' },
            { '<',        'V<<Esc>' },
            { '<Up>',     'gk' },
            { '<S-Up>',   '<C-u>' },
            { '<Down>',   'gj' },
            { '<S-Down>', '<C-d>' },
            -- { '/', searchbox.incsearch },

            { '<A-', {
                -- { 'a>', '<C-w>h' },
                -- { 'A>', '<cmd>WinShift left<CR>' },
                { 'Left>',    '<C-w>h' },
                { 'S-Left>',  '<cmd>WinShift left<CR>' },
                -- { 'a>', ':DiffviewFileHistory %<CR>' },
                -- { 'A>', ':DiffviewFileHistory<CR>' },
                -- { 'c>', 'Vgc^', options = { noremap = false } },
                -- { 'd>', '<C-w>l' },
                { 'Right>',   '<C-w>l' },
                { 'S-Right>', '<cmd>WinShift right<CR>' },
                -- { 'D>', '<cmd>WinShift right<CR>' },
                -- { 'e>', '<cmd>BufferPrev<CR>' },
                { 'e>',       '<cmd>BufferLineCyclePrev<CR>' },
                -- { 'E>', '<cmd>BufferMovePrev<CR>' },
                { 'E>',       '<cmd>BufferLineMovePrev<CR>' },
                -- { 'f>', '<cmd>BufferPick<CR>' },
                { 'f>',       '<cmd>BufferLinePick<CR>' },
                { 'g>',       ':DiffviewOpen<CR>' },
                { 'i>',       '2<C-w><' },
                { 'j>',       '2<Down>/function<CR>:noh<CR><Down>^zt' },
                { 'k>',       '2<Up>?function<CR>:noh<CR><Down>^zt' },
                { 'm>',       ':tabprevious<CR>' },
                { 'M>',       ':-tabmove<CR>' },
                { 'n>',       ':tabnext<CR>' },
                { 'N>',       ':+tabmove<CR>' },
                { 'o>',       '2<C-w>+' },
                { 'p>',       '2<C-w>-' },
                -- { 'r>', '<cmd>BufferNext<CR>' },
                { 'r>',       '<cmd>BufferLineCycleNext<CR>' },
                -- { 'R>', '<cmd>BufferMoveNext<CR>' },
                { 'R>',       '<cmd>BufferLineMoveNext<CR>' },
                -- { 's>', '<C-w>j' },
                -- { 'S>', '<cmd>WinShift down<CR>' },
                { 'Down>',    '<C-w>j' },
                { 'S-Down>',  '<cmd>WinShift down<CR>' },
                -- { 'q>', '<C-w>k' },
                -- { 'Q>', '<cmd>WinShift up<CR>' },
                -- { 't>', ':lua require("FTerm").toggle()<CR>' },
                { 't>',       ':ToggleTerm<CR>' },
                { 'u>',       '2<C-w>>' },
                { 'v>',       ':vsp<CR>' },
                { 'V>',       ':sp<CR>' },
                -- { 'w>', '<C-w>k' },
                -- { 'W>', '<cmd>WinShift up<CR>' },
                { 'Up>',      '<C-w>k' },
                { 'S-Up>',    '<cmd>WinShift up<CR>' },
                { 'y>',       '<C-w>=' },

                { '1>',       '<cmd>BufferLineGoToBuffer 1<CR>' },
                { '2>',       '<cmd>BufferLineGoToBuffer 2<CR>' },
                { '3>',       '<cmd>BufferLineGoToBuffer 3<CR>' },
                { '4>',       '<cmd>BufferLineGoToBuffer 4<CR>' },
                { '5>',       '<cmd>BufferLineGoToBuffer 5<CR>' },
                { '6>',       '<cmd>BufferLineGoToBuffer 6<CR>' },
                { '7>',       '<cmd>BufferLineGoToBuffer 7<CR>' },
                { '8>',       '<cmd>BufferLineGoToBuffer 8<CR>' },
                { '9>',       '<cmd>BufferLineGoToBuffer 9<CR>' },

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
            } },

            { '<leader>', {
                { 'b', function() startBuild() end },
                -- { 'b', startBuild },
                { 'e', ':NvimTreeToggle<CR>' },
                { 'E', ':NvimTreeFindFile<CR>' },
                { 'f', {
                    { 'e', 'za' },
                    { 'f', lsp.format },
                    { 'r', 'zA' },
                } },
                { 'm', ':TSJToggle<CR>' },
                -- h: replace word under cursor
                { 'o', ':AerialToggle<CR>' },
                -- { 'r', searchReplace},
                -- { 'o', ':SymbolsOutline<CR>' },
                { 'w', watchTerm },
            } },
        }
    },

    {
        mode = 'i',
        {
            { 'jk',     '<Esc>`^' },
            { '<Up>',   '<Esc>g<Up>a' },
            { '<Down>', '<Esc>g<Down>a' },
            { '<C-', {
                -- { 'i>', '<Backspace><Backspace><Backspace><Backspace><Backspace>' },
                -- { 'o>', '&emsp;' },
                { 'j>', '<Esc>:m .+1<CR>==gi' },
                { 'k>', '<Esc>:m .-2<CR>==gi' },
                { 'v>', '<Esc>p' },
            } }
        }
    },

    {
        mode = 'v',
        {
            { 's',      ':Sort ui<CR>' },
            { 'j',      function() leap_to_line(false) end },
            { 'J',      '12<Down>' },
            { 'k',      function() leap_to_line(true) end },
            { 'K',      '12<Up>' },

            { '<Space', '<Nop>' },
            { '>',      '>gv' },
            { '<',      '<gv' },

            -- { '<A-', {
            --     { 'c>', 'gc^', options = { noremap = false } },
            -- } },
            { 'm',      'gc^',                             options = { noremap = false } },
            { '<C-', {
                { 'j>', ":m '>+1<CR>gv=gv" },
                { 'k>', ":m '<-2<CR>gv=gv" },
            } }
        }
    },

    {
        mode = 't',
        {
            { '<A-', {
                { 't>', '<C-\\><C-n>:lua require("FTerm").toggle()<CR>' },
            } }
        }
    }
}

-- result of vim.fn.winlayout()
local winLayout = {
    "row",
    { { "leaf", 1000 }, { "col", { { "leaf", 1002 }, { "leaf", 1018 } } }, { "leaf", 1013 } },
}

-- current win id (1002) can be retrieved with vim.fn.win_getid()

--[[
alt arrows : move between windows
alt shift arrows : move windows around

shift up/down: ctrl d / u
home/end for buffer right/left?
shift home/end for move buffer right/left
in n mode: v -> V
in v mode: p -> P

need something to toggle comment
m is possible

could swap h and l for w and b
that would potentially free up w, be and e
how often to we actually use e anyways?


--]]
