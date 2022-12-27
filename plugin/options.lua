local o = vim.opt

o.signcolumn = 'auto'
o.autoindent = true
o.background = 'dark'
o.backup = false
o.clipboard = 'unnamedplus'
o.compatible = false
o.cursorline = true
o.expandtab = true
o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
o.foldcolumn = 'auto:1'
o.hidden = true
o.hlsearch = true
o.ignorecase = true
o.incsearch = true
o.iskeyword:append('-')
o.laststatus = 3
o.list = false
o.mouse = 'a'
o.number = false
o.scrolloff = 8
o.sessionoptions:append('globals', 'tabpages')
o.shiftround = true
o.shiftwidth = 4
o.showmatch = true
o.showmode = false
o.smartcase = true
o.softtabstop = 4
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 4
o.updatetime = 1400
o.writebackup = false
