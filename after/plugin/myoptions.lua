local o = vim.opt

local function cwd()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

-- o.foldexpr = 'nvim_treesitter#foldexpr()'
-- o.foldlevel = 99
-- o.foldlevelstart = 99
-- o.foldmethod = 'indent'
-- o.iskeyword:append('-')
-- o.sessionoptions:append('globals', 'tabpages')
o.clipboard = "unnamedplus"
o.cmdheight = 1
o.copyindent = true
o.cursorline = true
o.expandtab = true
o.fillchars:append({ eob = " " })
o.fillchars:append({ horiz = "━" })
o.fillchars:append({ horizup = "━" })
o.fillchars:append({ horizdown = "━" })
o.fillchars:append({ vert = "┃" })
o.fillchars:append({ vertleft = "┃" })
o.fillchars:append({ vertright = "┃" })
o.fillchars:append({ verthoriz = "┃" })
o.foldenable = false
o.laststatus = 3
o.linebreak = true
o.mouse = "a"
o.pumheight = 10
o.scrolloff = 8
o.shiftround = true
o.shiftwidth = 4
o.shortmess:append("I")
o.shortmess:append("S")
o.shortmess:append("s")
o.showbreak = " 󱞪 "
o.showcmd = false
o.showmode = false
o.signcolumn = "auto"
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 4
o.termguicolors = true
o.title = true
o.undofile = true
o.updatetime = 1000
o.writebackup = false
vim.o.titlestring = "NVIM  in  " .. cwd()
