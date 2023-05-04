local o = vim.opt

o.autoindent = true
o.background = 'dark'
o.backup = false
o.clipboard = 'unnamedplus'
o.cmdheight = 1
o.compatible = false
o.cursorline = true
-- o.cursorcolumn = true
-- o.cmdheight = 0
o.expandtab = true
o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
o.foldcolumn = '0'
o.foldenable = false
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = 'indent'
o.foldexpr = 'nvim_treesitter#foldexpr()'
o.hidden = true
o.hlsearch = true
o.ignorecase = false
o.incsearch = true
o.iskeyword:append('-')
o.laststatus = 3
o.list = false
-- o.listchars = [[tab:▏,multispace:▏   ]]
o.mouse = 'a'
o.number = false
o.scrolloff = 8
o.sessionoptions:append('globals', 'tabpages')
o.shiftround = true
o.shiftwidth = 4
o.showcmd = false
o.showmatch = true
o.shortmess:append('I')
o.shortmess:append('S')
o.shortmess:append('s')
o.showmode = false
o.signcolumn = 'auto'
o.smartcase = false
o.softtabstop = 4
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 4
o.updatetime = WINDOWS and 1000 or 600
o.undodir = vim.fn.stdpath('data') .. '/undodir'
o.undofile = true
o.writebackup = false
