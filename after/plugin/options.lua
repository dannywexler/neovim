local o = vim.opt

local function cwd()
	return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

o.clipboard = "unnamedplus"
o.cmdheight = 1
o.copyindent = true
o.cursorline = true
o.expandtab = true
o.foldenable = false
-- o.foldlevel = 99
-- o.foldlevelstart = 99
-- o.foldmethod = 'indent'
-- o.foldexpr = 'nvim_treesitter#foldexpr()'
-- o.iskeyword:append('-')
o.laststatus = 3
o.linebreak = true
o.mouse = "a"
o.pumheight = 10
o.scrolloff = 8
-- o.sessionoptions:append('globals', 'tabpages')
o.shiftround = true
o.shiftwidth = 4
o.showcmd = false
o.shortmess:append("I")
o.shortmess:append("S")
o.shortmess:append("s")
o.signcolumn = "auto"
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 4
o.title = true
o.updatetime = 1000
o.undofile = true
o.writebackup = false
o.showbreak = " 󱞪 "
o.termguicolors = true
vim.o.titlestring = cwd() .. " - NVIM"
