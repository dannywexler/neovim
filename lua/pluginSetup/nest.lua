local leap = require("leap")
local nest = require("nest")
local sleekerrors = require("my.customPlugins.sleekerrors")
local neowords = require("neowords")
local pat = neowords.pattern_presets
local nword = neowords.get_word_hops(
	-- pat.snake_case,
	-- pat.camel_case,
	-- pat.upper_case,
	pat.any_word,
	pat.number
)
-- local searchbox = require 'searchbox'
-- local tree = require 'tree-climber'
-- local treeopts = {
--     skip_comments = true,
--     highlight = true,
-- }

local function nmap(left, right)
	vim.keymap.set("n", left, right)
end

local lsp = vim.lsp.buf
local diag = vim.diagnostic
local telescope = require("telescope.builtin")

vim.g.mapleader = " "

local function get_line_starts(winid, searchAbove)
	local wininfo = vim.fn.getwininfo(winid)[1]
	local cur_line = vim.fn.line(".")
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
			if lnum ~= cur_line then
				table.insert(targets, { pos = { lnum, 1 } })
			end
			lnum = lnum + 1
		end
	end
	-- Sort them by vertical screen distance from cursor.
	local cur_screen_row = vim.fn.screenpos(winid, cur_line, 1)["row"]
	local function screen_rows_from_cur(t)
		local t_screen_row = vim.fn.screenpos(winid, t.pos[1], t.pos[2])["row"]
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
	leap.leap({
		target_windows = { winid },
		targets = get_line_starts(winid, searchAbove),
	})
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

local function smartOpen()
	require("telescope").extensions.smart_open.smart_open({
		cwd_only = true,
		filename_first = true,
	})
end

local function formatFile()
	-- lsp.format()
	require("conform").format({
		async = true,
		lsp_fallback = true,
	})
	-- sleekerrors.newDiagnostics[vim.fn.bufnr()] = true
end

local function gotoWindow(windowNumber)
	return tostring(windowNumber) .. "<C-w>w"
end

nmap("<leader>r", ':%s@<c-r>=expand("<cword>")<cr>@@gc<Left><Left><Left>')

local scroll = {
	up = '<cmd>lua require "neoscroll".scroll(-vim.wo.scroll, true, 150, "circular")<cr>',
	down = '<cmd>lua require "neoscroll".scroll(vim.wo.scroll, true, 150, "circular")<cr>',
}

nest.applyKeymaps({
	{
		mode = "n",
		{
			{ "b", nword.backward_start },
			{ "e", nword.forward_end },
			{
				"g",
				{
					-- { 'a', lsp.code_action},
					-- { 'a', '<cmd>CodeActionMenu<CR>' },
					{ "a", "<cmd>Lspsaga code_action<CR>" },
					{ "d", lsp.definition },
					{
						"e",
						function()
							-- diag.goto_prev({float = true})
							require("lspsaga.diagnostic"):goto_prev()
						end,
					},
					{
						"f",
						function()
							-- diag.goto_next({float = true})
							-- require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
							require("lspsaga.diagnostic"):goto_next()
						end,
					},
					-- { 'h', lsp.hover },
					{ "h", "<cmd>Lspsaga hover_doc ++quiet<CR>" },
					{ "n", lsp.rename },
					{ "r", telescope.lsp_references },
					{
						"s",
						function()
							vim.cmd.vsplit()
							telescope.lsp_definitions()
							vim.wait(50)
							vim.cmd.norm("zt")
							-- telescope.lsp_definitions({ jump_type = "vsplit" })
							-- vim.wait(50)
							-- vim.cmd.norm("zt")
						end,
					},
				},
			},
			{ "h", scroll.up },
			-- { 'H', function () tree.goto_parent(treeopts) end},
			{
				"H",
				"<Plug>(IndentWisePreviousLesserIndent)",
				options = { noremap = false },
			},
			{
				"j",
				function()
					leap.leap({})
				end,
			},
			-- { 'J', '20<Down>' },
			-- { 'J', function () tree.goto_next(treeopts) end},
			{
				"J",
				"<Plug>(IndentWiseNextEqualIndent)",
				options = { noremap = false },
			},
			{
				"k",
				function()
					leap.leap({ backward = true })
				end,
			},
			-- { 'K', '20<Up>' },
			-- { 'K', function () tree.goto_prev(treeopts) end},
			{
				"K",
				"<Plug>(IndentWisePreviousEqualIndent)",
				options = { noremap = false },
			},
			-- { 'L', function () tree.goto_child(treeopts) end},
			{ "l", scroll.down },
			{
				"L",
				"<Plug>(IndentWiseNextGreaterIndent)",
				options = { noremap = false },
			},
			{
				"q",
				{
					{ "e", ":tabclose<CR>" },
					{ "f", ":bp | bd #<CR>" },
					-- { 'f', ':BufferClose<CR>' },
					-- { 'q', ':qa!<CR>' },
					{ "q", ":NvimTreeClose<CR>:qa!<CR>" },
					{ "w", "ZZ" },
				},
			},
			{ "s", "<NOP>" },

			{
				"s",
				{
					-- {'g', spectre.open_visual({select_word=true})},
					{ "'", "vi':Sort ui<CR>" },
					{ '"', 'vi":Sort ui<CR>' },
					{ "a", telescope.live_grep },
					-- { 'd', telescope.find_files },
					{
						"d",
						function()
							require("telescope.builtin").find_files()
						end,
					},
					{ "e", "<cmd>Lspsaga show_buf_diagnostics<CR>" },
					{ "E", "<cmd>Lspsaga show_workspace_diagnostics<CR>" },
					{ "f", telescope.lsp_document_symbols },
					-- {
					-- 	"h",
					-- 	function()
					-- 		require("smart-splits").move_cursor_up()
					-- 	end,
					-- },
					{
						"H",
						function()
							require("smart-splits").swap_buf_up()
						end,
					},
					{ "i", "<C-i>" },
					-- {
					-- 	"j",
					-- 	function()
					-- 		require("smart-splits").move_cursor_right()
					-- 	end,
					-- },
					{
						"J",
						function()
							require("smart-splits").swap_buf_right()
						end,
					},
					-- {
					-- 	"k",
					-- 	function()
					-- 		require("smart-splits").move_cursor_left()
					-- 	end,
					-- },
					{
						"K",
						function()
							require("smart-splits").swap_buf_left()
						end,
					},
					-- {
					-- 	"l",
					-- 	function()
					-- 		require("smart-splits").move_cursor_down()
					-- 	end,
					-- },
					{
						"L",
						function()
							require("smart-splits").swap_buf_down()
						end,
					},
					-- { "h", telescope.highlights },
					-- { "H", telescope.help_tags },
					-- { 'i', "vii:'<,'>Sort ui<CR>" },
					{ "o", "<C-o>" },
					{ "p", "Vip:Sort ui<CR>" },
					-- {
					-- 	"s",
					-- 	function()
					-- 		leap.leap({
					-- 			target_windows = require("leap.util").get_enterable_windows(),
					-- 		})
					-- 	end,
					-- },
					{ "w", telescope.grep_string },
					{ "{", "vi{:Sort ui<CR>" },
					{ "[", "vi[:Sort ui<CR>" },
					{ "|", "vi|:Sort ui<CR>" },
				},
			},
			{ "U", "<C-r>" },
			{ "v", "V" },
			{ "V", "v" },
			{ "w", nword.forward_start },
			{
				"z",
				{
					{
						"h",
						function()
							vim.fn.setreg("/", "wxyz")
							vim.cmd("noh")
						end,
					},
				},
			},

			{ "<Space>", "<NOP>" },
			-- { '>',        'V><Esc>' },
			-- { '<',        'V<<Esc>' },
			{ "<Up>", "gk" },
			-- { '<S-Up>',   '<C-u>' },
			{ "<S-Up>", scroll.up },
			{ "<Down>", "gj" },
			-- { '<S-Down>', '<C-d>' },
			{ "<S-Down>", scroll.down },
			-- { '/', searchbox.incsearch },

			{
				"<A-",
				{
					-- { 'a>', '<C-w>h' },
					-- { 'A>', '<cmd>WinShift left<CR>' },
					{ "Left>", "<C-w>h" },
					{ "S-Left>", "<cmd>WinShift left<CR>" },
					-- { 'a>', ':DiffviewFileHistory %<CR>' },
					-- { 'A>', ':DiffviewFileHistory<CR>' },
					-- { 'c>', 'Vgc^', options = { noremap = false } },
					-- { 'd>', '<C-w>l' },
					{ "Right>", "<C-w>l" },
					{ "S-Right>", "<cmd>WinShift right<CR>" },
					-- { 'D>', '<cmd>WinShift right<CR>' },
					-- { 'e>', '<cmd>BufferPrev<CR>' },
					{ "e>", "<cmd>BufferLineCyclePrev<CR>" },
					-- { 'E>', '<cmd>BufferMovePrev<CR>' },
					{ "E>", "<cmd>BufferLineMovePrev<CR>" },
					-- { 'f>', '<cmd>BufferPick<CR>' },
					{ "f>", "<cmd>BufferLinePick<CR>" },
					{ "h>", "<C-w>h" },
					{ "H>", "<cmd>WinShift left<CR>" },
					{ "i>", "2<C-w><" },
					-- { 'j>',       '2<Down>/function<CR>:noh<CR><Down>^zt' },
					{ "j>", "<C-w>j" },
					{ "J>", "<cmd>WinShift down<CR>" },
					-- { 'k>',       '2<Up>?function<CR>:noh<CR><Down>^zt' },
					{ "k>", "<C-w>k" },
					{ "K>", "<cmd>WinShift up<CR>" },
					{ "l>", "<C-w>l" },
					{ "L>", "<cmd>WinShift right<CR>" },
					{ "m>", ":tabprevious<CR>" },
					{ "M>", ":-tabmove<CR>" },
					{ "n>", ":tabnext<CR>" },
					{ "N>", ":+tabmove<CR>" },
					{ "o>", "2<C-w>+" },
					{ "p>", "2<C-w>-" },
					-- { 'r>', '<cmd>BufferNext<CR>' },
					{ "r>", "<cmd>BufferLineCycleNext<CR>" },
					-- { 'R>', '<cmd>BufferMoveNext<CR>' },
					{ "R>", "<cmd>BufferLineMoveNext<CR>" },
					-- { 's>', '<C-w>j' },
					-- { 'S>', '<cmd>WinShift down<CR>' },
					{ "Down>", "<C-w>j" },
					{ "S-Down>", "<cmd>WinShift down<CR>" },
					-- { 'q>', '<C-w>k' },
					-- { 'Q>', '<cmd>WinShift up<CR>' },
					-- { 't>', ':lua require("FTerm").toggle()<CR>' },
					{ "u>", "2<C-w>>" },
					-- { 'w>', '<C-w>k' },
					-- { 'W>', '<cmd>WinShift up<CR>' },
					{ "Up>", "<C-w>k" },
					{ "S-Up>", "<cmd>WinShift up<CR>" },
					{ "y>", "<C-w>=" },

					{ "1>", "<cmd>BufferLineGoToBuffer 1<CR>" },
					{ "2>", "<cmd>BufferLineGoToBuffer 2<CR>" },
					{ "3>", "<cmd>BufferLineGoToBuffer 3<CR>" },
					{ "4>", "<cmd>BufferLineGoToBuffer 4<CR>" },
					{ "5>", "<cmd>BufferLineGoToBuffer 5<CR>" },
					{ "6>", "<cmd>BufferLineGoToBuffer 6<CR>" },
					{ "7>", "<cmd>BufferLineGoToBuffer 7<CR>" },
					{ "8>", "<cmd>BufferLineGoToBuffer 8<CR>" },
					{ "9>", "<cmd>BufferLineGoToBuffer 9<CR>" },

					-- { '1>', '<cmd>BufferGoto 1<CR>' },
					-- { '2>', '<cmd>BufferGoto 2<CR>' },
					-- { '3>', '<cmd>BufferGoto 3<CR>' },
					-- { '4>', '<cmd>BufferGoto 4<CR>' },
					-- { '5>', '<cmd>BufferGoto 5<CR>' },
					-- { '6>', '<cmd>BufferGoto 7<CR>' },
					-- { '7>', '<cmd>BufferGoto 8<CR>' },
					-- { '8>', '<cmd>BufferGoto 9<CR>' },
				},
			},

			{
				"<C-",
				{
					{ "b>", ":sp<CR>" },
					{ "g>", ":DiffviewOpen<CR>" },
					{ "h>", "V<<Esc>" },
					{ "j>", ":m .+1<CR>==" },
					{ "k>", ":m .-2<CR>==" },
					{ "l>", "V><Esc>" },
					{ "v>", ":vsp<CR>" },
				},
			},

			{
				"<leader>",
				{
					{ "a", gotoWindow(1) },
					{ "b", startBuild },
					{ "d", gotoWindow(3) },
					{ "e", ":NvimTreeToggle<CR>" },
					{ "E", ":NvimTreeFindFile<CR>" },
					{ "f", gotoWindow(4) },
					{ "g", gotoWindow(5) },
					{ "m", ":TSJToggle<CR>" },
					-- h: replace word under cursor
					{ "o", ":AerialToggle<CR>" },
					-- { 'r', searchReplace},
					-- { 'o', ':SymbolsOutline<CR>' },
					{ "p", formatFile },
					{ "s", gotoWindow(2) },
					{
						"t",
						function()
							vim.g.sleekerrors_hide = not vim.g.sleekerrors_hide
							sleekerrors.getAllDiagnostics()
						end,
					},
					{ "v", ":vsp<CR>" },
					{ "w", watchTerm },
				},
			},
		},
	},

	{
		mode = "i",
		{
			{ "jk", "<Esc>`^" },
			{ "<Up>", "<Esc>g<Up>a" },
			{ "<Down>", "<Esc>g<Down>a" },
			{
				"<C-",
				{
					-- { 'i>', '<Backspace><Backspace><Backspace><Backspace><Backspace>' },
					-- { 'o>', '&emsp;' },
					{ "j>", "<Esc>:m .+1<CR>==gi" },
					{ "k>", "<Esc>:m .-2<CR>==gi" },
					{ "v>", "<Esc>p" },
					{ "Enter>", "<Esc>o" },
				},
			},
		},
	},

	{
		mode = "v",
		{
			{ "s", ":Sort ui<CR>" },
			{
				"j",
				function()
					leap_to_line(false)
				end,
			},
			{ "J", "12<Down>" },
			{
				"k",
				function()
					leap_to_line(true)
				end,
			},
			{ "K", "12<Up>" },

			{ "<Space", "<Nop>" },
			-- { '>',      '>gv' },
			-- { '<',      '<gv' },

			-- { '<A-', {
			--     { 'c>', 'gc^', options = { noremap = false } },
			-- } },
			{ "m", "gc^", options = { noremap = false } },
			{
				"<C-",
				{
					{ "h>", "<gv" },
					{ "j>", ":m '>+1<CR>gv=gv" },
					{ "k>", ":m '<-2<CR>gv=gv" },
					{ "l>", ">gv" },
				},
			},
		},
	},

	{
		mode = "t",
		{
			{
				"<A-",
				{
					{ "t>", '<C-\\><C-n>:lua require("FTerm").toggle()<CR>' },
				},
			},
		},
	},
})

-- result of vim.fn.winlayout()
local winLayout = {
	"row",
	{
		{ "leaf", 1000 },
		{ "col", { { "leaf", 1002 }, { "leaf", 1018 } } },
		{ "leaf", 1013 },
	},
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
`@%#`

could use home/end as direct ctrl d/ctrl u scrolling

then would need some other way to switch between open buffers

if want to have the bufferPick, that would need to be added somewhere to nav layer

All buffer related actions:
switching left/right
moving left/right
selecting by index
selecting by first letter picker

Possible to have them all be on num layer by putting
    left/right on i(`), o(@)
    pick by name on %#
    pick by numbers (already there)
    shift is already available on j key, right near iop

This way all window-related movement is on nav layer
and all buffer-related movement is on num layer

however, it might not be ideal to have the buffer and window nav be on different layers
often want to move a window, then select a new buffer right after

could use alt for window related, and ctrl for buffer related

however, would be nice to have ctrl + arrow keys available for something, like maybe ctrl up/down for moving lines up/down instead of ctrl j/k for moving lines up/down

could consider moveing the window resizing commands that are currently on alt + uiop potentially onto {somePrefix} + up/down/left/right

moving between windows and moving windows around are super common actions, much more frequent that window resizing. based on that, maybe should move the window moving and switching to ctrl + up/down/left/right, since ctrl (+shift?) is easier to hit than alt (+shift?)

would be nice to figure out tab related movement, but way lower priority
--]]
