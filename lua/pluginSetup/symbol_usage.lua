require("symbol-usage").setup({
	definition = { enabled = false },
	implementation = { enabled = false },
	references = { enabled = true, include_declaration = false },
	text_format = function(symbol)
		local refs = symbol.references
		local res = {}

		if refs then
			table.insert(res, { "   ", "NonText" })
			local text = ""
			if refs == 0 then
				text = "Never Used"
			elseif refs == 1 then
				text = "1 Usage"
			else
				text = tostring(refs) .. " Usages"
			end
			table.insert(res, { " 󰌹 ", "SymbolUsages" })
			table.insert(res, { text, "SymbolUsages" })
			table.insert(res, { " ", "SymbolUsages" })
		end
		return res
	end,
	vt_position = "end_of_line",
})
