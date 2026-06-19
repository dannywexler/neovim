local o = vim.opt

local prefixes = { "C:/nn/shared/code/", "C:/OneDrive/OneDrive - GDIT/" }

local function cwd()
    local path = vim.fn.fnamemodify(vim.fn.getcwd(), ":~:gs?\\?/?")
    for _, prefix in ipairs(prefixes) do
        if vim.startswith(path, prefix) then
            return string.sub(path, #prefix + 1)
        end
    end
    return "NVIM " .. path
end

-- o.foldexpr = 'nvim_treesitter#foldexpr()'
-- o.foldlevel = 99
-- o.foldlevelstart = 99
-- o.foldmethod = 'indent'
-- o.iskeyword:append('-')
o.sessionoptions:append('globals', 'tabpages', 'localoptions')
o.cmdheight = 0
o.copyindent = true
o.cursorline = true
o.expandtab = true
o.fillchars:append({ eob = " " })
o.fillchars:append({ horiz = "━" })
o.fillchars:append({ horizdown = "┳" })
o.fillchars:append({ horizup = "┻" })
o.fillchars:append({ vert = "┃" })
o.fillchars:append({ verthoriz = "╋" })
o.fillchars:append({ vertleft = "┫" })
o.fillchars:append({ vertright = "┣" })
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
o.winborder = "bold"
o.writebackup = false
vim.o.titlestring = cwd()


if vim.fn.executable("nu") == 1 then
    vim.o.shell = "nu"
elseif WINDOWS then
    vim.o.shell = "powershell"
    vim.o.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
    vim.o.shellxquote = ""
end
