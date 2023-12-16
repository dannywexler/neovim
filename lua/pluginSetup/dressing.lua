require("dressing").setup({
	input = {
		win_options = {
			winblend = 0,
		},
		width = 35,
		get_config = function(opts)
			-- local options = vim.inspect(opts)
			-- print('options: ')
			-- print(options)
			local kind = opts.kind or "nil"
			-- print('input kind: ' .. kind)
			if kind == "codeaction" then
				return {
					width = 60,
				}
			elseif kind == "gitcommit" then
				return {
					relative = "editor",
					width = 120,
				}
			elseif opts.prompt == "Create file " then
				-- print('creating file')
				return {
					relative = "editor",
					width = 120,
				}
			end
		end,
	},
})
