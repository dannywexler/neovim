local prettyfold = require("pretty-fold")
prettyfold.setup({
	process_comment_signs = false,
	sections = {
		left = {
			"content",
			-- function() return string.rep(' ', 4) end,
			" ",
			function(config)
				return config.fill_char:rep(4)
			end,
			" ",
			"number_of_folded_lines",
			" ",
		},
		-- right = {
		--     function(config) return config.fill_char:rep(4) end,
		-- }
	},
	-- sections = {
	--     left = {
	--         'content',
	--     },
	--     right = {
	--         ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
	--         function(config) return config.fill_char:rep(3) end
	--     }
	-- },
})

prettyfold.ft_setup("lua", {
	process_comment_signs = false,
	sections = {
		left = {
			"content",
			-- function() return string.rep(' ', 4) end,
			" ",
			function(config)
				return config.fill_char:rep(4)
			end,
			" ",
			"number_of_folded_lines",
			" ",
		},
		-- right = {
		--     function(config) return config.fill_char:rep(4) end,
		-- }
	},
	matchup_patterns = {
		{ "^%s*do$", "end" }, -- do ... end blocks
		{ "^%s*if", "end" }, -- if ... end
		{ "^%s*for", "end" }, -- for
		{ "function%s*%(", "end" }, -- 'function( or 'function (''
		{ "{", "}" },
		{ "%(", ")" }, -- % to escape lua pattern char
		{ "%[", "]" }, -- % to escape lua pattern char
	},
})
