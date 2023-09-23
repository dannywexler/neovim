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

require 'lazy'.setup(
    'd.lazy.mergePlugins',
    {
        concurrency = U.LINUX and nil or 2,
        change_detection = {
            enabled = true,
            notify = true,
        },
        defaults = {
            lazy = false
        },
        git = {
            timeout = nil
        },
        install = {
            colorscheme = { 'tokyonight', 'habamax' }
        },
        lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
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
                    "vimball",
                    "vimballPlugin",
                    "zip",
                    "zipPlugin",
                    "tutor",
                }
            }
        },
        ui = {
            border = 'rounded',
            size = {
                height = 0.92,
                width = 0.92
            },
            throttle = U.LINUX and 20 or 200
        }
    }
)
