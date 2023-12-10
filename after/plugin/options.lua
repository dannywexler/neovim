local o = vim.opt

local function cwd()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
end

o.autoindent = true
o.background = 'dark'
o.backup = false
o.clipboard = 'unnamedplus'
o.cmdheight = 1
o.copyindent = true
-- o.compatible = false
o.cursorline = true
-- o.cursorcolumn = true
-- o.cmdheight = 0
o.expandtab = true
-- -- o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- o.foldcolumn = '0'
o.foldenable = false
-- o.foldlevel = 99
-- o.foldlevelstart = 99
-- o.foldmethod = 'indent'
-- o.foldexpr = 'nvim_treesitter#foldexpr()'
-- o.iskeyword:append('-')
o.laststatus = 3
o.linebreak = true
o.mouse = 'a'
o.more = false --When on, listings pause when the whole screen is filled.  You will get the |more-prompt|.  When this option is off there are no pauses, the listing continues until finished.
-- o.number = false
o.pumheight = 10
o.scrolloff = 8
-- -- o.sessionoptions:append('globals', 'tabpages')
o.shiftround = true
o.shiftwidth = 4
o.showcmd = false
-- o.showmatch = true
o.shortmess:append('I')
o.shortmess:append('S')
o.shortmess:append('s')
o.showmode = false
o.signcolumn = 'auto'
-- o.smartcase = false
-- o.softtabstop = 4
-- o.softtabstop
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 4
o.title = true
vim.o.titlestring = cwd() .. ' - NVIM'
o.updatetime = 1000
-- o.updatetime = WINDOWS and 1000 or 600
-- -- o.undodir = vim.fn.stdpath('data') .. '/undodir'
o.undofile = true
o.writebackup = false
o.number = false
o.relativenumber = false
o.linebreak = true
o.showbreak = '󱞪 '
o.termguicolors = true
