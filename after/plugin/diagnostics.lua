vim.diagnostic.config({
	float = {
		border = "rounded",
		focusable = false,
		header = "",
		prefix = "",
		source = false,
		style = "minimal",
	},
	-- show signs
	-- signs = {
	--     active = signs,
	-- },
	signs = false,
	severity_sort = true,
	update_in_insert = false,
	underline = true,
	-- virtual_text = {
	--     severity = "ERROR"
	-- },
	virtual_text = false,
	-- virtual_text = {
	--     format = function(diagnostic)
	--         -- if diagnostic.severity == vim.diagnostic.severity.ERROR then
	--         -- return string.format("E: %s", diagnostic.message)
	--         -- end
	--         if diagnostic.severity == vim.diagnostic.severity.HINT then
	--             return 'HINT'
	--         elseif diagnostic.severity == vim.diagnostic.severity.WARN then
	--             return 'WARN'
	--         elseif diagnostic.severity == vim.diagnostic.severity.INFO then
	--             return 'INFO'
	--             -- elseif diagnostic.severity == vim.diagnostic.severity.ERROR then
	--             --     return 'ERROR'
	--         end
	--         return diagnostic.message
	--     end,
	--     prefix = '●',
	--     source = false,
	-- },
})
