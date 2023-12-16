require("telescope-all-recent").setup({
	database = {
		folder = vim.fn.stdpath("data"),
		file = "telescope-all-recent.sqlite3",
		max_timestamps = 20,
	},
	debug = false,
	scoring = {
		recency_modifier = { -- also see telescope-frecency for these settings
			[1] = { age = 240, value = 100 }, -- past 4 hours
			[2] = { age = 1440, value = 80 }, -- past day
			[3] = { age = 4320, value = 60 }, -- past 3 days
			[4] = { age = 10080, value = 40 }, -- past week
			[5] = { age = 43200, value = 20 }, -- past month
			[6] = { age = 129600, value = 10 }, -- past 90 days
		},
		-- how much the score of a recent item will be improved.
		boost_factor = 0.0001,
	},
	default = {
		disable = true, -- disable any unkown pickers (recommended)
		use_cwd = true, -- differentiate scoring for each picker based on cwd
		sorting = "frecency", -- sorting: options: 'recent' and 'frecency'
	},
	pickers = { -- allows you to overwrite the default settings for each picker
		builtin = { disable = false, use_cwd = false },
		command_history = { disable = true },
		commands = { disable = true, use_cwd = false },
		current_buffer_fuzzy_find = { disable = true },
		find_files = { disable = false, use_cwd = true, sorting = "frecency" },
		git_branches = { disable = true },
		git_commits = { disable = true },
		git_files = { disable = false, sorting = "frecency" },
		grep_string = { disable = true },
		help_tags = { disable = false, use_cwd = false },
		live_grep = { disable = true },
		man_pages = { disable = false, use_cwd = false, sorting = "frecency" },
		oldfiles = { disable = true },
		pickers = { disable = true, use_cwd = false },
		planets = { disable = true, use_cwd = false },
		search_history = { disable = true },
		tags = { disable = true },
		vim_options = { disable = false, use_cwd = false },
	},
})
