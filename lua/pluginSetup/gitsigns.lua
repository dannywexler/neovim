local signs = {
	add = " ",
	change = " ",
	delete = " ",
	untracked = " ",
}

require("gitsigns").setup({
	attach_to_untracked = true,
	signs = {
		add = { text = signs.add },
		change = { text = signs.change },
		delete = { text = signs.delete },
		topdelete = { text = signs.delete },
		changedelete = { text = signs.delete },
		untracked = { text = signs.untracked },
	},
	signs_staged = {
		add = { text = signs.add },
		change = { text = signs.change },
		delete = { text = signs.delete },
		topdelete = { text = signs.delete },
		changedelete = { text = signs.delete },
		untracked = { text = signs.untracked },
	},
	update_debounce = 100,
	watch_gitdir = {
		follow_files = true,
	},
})
