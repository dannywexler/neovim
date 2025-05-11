local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
    change_detection = {
        notify = false,
    },
    concurrency = 1,
    defaults = {
        lazy = false,
    },
    git = {
        timeout = nil,
    },
    install = {
        colorscheme = { "tokyonight" },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "matchparen",
                "netrw",
                "netrwFileHandlers",
                "netrwPlugin",
                "netrwSettings",
                "rrhelper",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
    spec = {
        { import = "plugins" },
    },
    throttle = {
        enabled = WINDOWS,
        rate = 1,
        duration = 2 * 1000, -- in ms
    },
    ui = {
        border = "rounded",
        size = {
            height = 0.95,
            width = 0.99,
        },
        throttle = WINDOWS and 200 or 20,
        title = "Lazy",
    },
})
