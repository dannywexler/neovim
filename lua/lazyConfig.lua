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

local pluginSpec = require("myplugins")
-- print(vim.inspect(pluginSpec))
require("lazy").setup(pluginSpec, {
	concurrency = WINDOWS and 2 or nil,
	defaults = {
		lazy = false,
	},
	git = {
		timeout = nil,
	},
	install = {
		colorscheme = { "tokyonight", "habamax" },
	},
	lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
	performance = {
		rtp = {
			-- disabled_plugins = {
			--     "gzip",
			--     "matchit",
			--     "matchparen",
			--     "netrwPlugin",
			--     "tarPlugin",
			--     "tohtml",
			--     -- "tutor",
			--     "zipPlugin",
			-- },
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
				-- "tutor",
			},
		},
	},
	ui = {
		border = "rounded",
		size = {
			height = 0.92,
			width = 0.92,
		},
		throttle = WINDOWS and 200 or 20,
	},
})

-- nvim --headless "+Lazy! sync" +qa
