local sleekerrors = require("my.customPlugins.sleekerrors")

local api = vim.api
local myGroup = api.nvim_create_augroup("MyGroup", { clear = true })
local aucmd = function(event, opts)
	local defaultOpts = { group = myGroup }
	local mergedOpts = vim.tbl_extend("force", defaultOpts, opts)

	api.nvim_create_autocmd(event, mergedOpts)
end

local filetypesToAutoFormat = { "lua" }

local function formatFile(buf, bufopt)
	local ft = bufopt.ft
	if not vim.tbl_contains(filetypesToAutoFormat, ft) then
		return
	end
	local errorCount = vim.tbl_count(vim.diagnostic.get(buf, {
		severity = vim.diagnostic.severity.ERROR,
	}))
	if errorCount > 0 then
		return
	end
	-- vim.lsp.buf.format({ bufnr = buf })
	require("conform").format({ async = false, lsp_fallback = true })
	-- print("Formatted", _G.fileName(buf))
	-- sleekerrors.newDiagnostics[buf] = true
end

local function saveFile(event)
	local bufopt = vim.bo[event.buf]

	if
		not bufopt.modifiable
		or not bufopt.modified
		or #bufopt.buftype > 0
		or #vim.fn.bufname(event.buf) == 0
	then
		return
	end
	formatFile(event.buf, bufopt)
	vim.cmd("silent write")
	-- sleekerrors.getAllDiagnostics()
	-- sleekerrors.onCursorHold(event)
	-- sleekerrors.getDiagnostics(event.buf)
end

local function allVisibleLines()
	local allWindows = vim.tbl_filter(function(item)
		return item.width > 1 and vim.api.nvim_buf_is_loaded(item.bufnr)
	end, vim.fn.getwininfo())
	local condensed = vim.tbl_map(function(item)
		return {
			bufnr = item.bufnr,
			botline = item.botline,
			topline = item.topline,
		}
	end, allWindows)
	print("condensed info:", vim.inspect(condensed))
end

aucmd("BufLeave", {
	callback = saveFile,
})

aucmd("CursorHold", {
	callback = function(event)
		saveFile(event)
		-- sleekerrors.onCursorHold(event)
		sleekerrors.getAllDiagnostics()
		-- allVisibleLines()
	end,
})

-- aucmd("DiagnosticChanged", {
--     callback = sleekerrors.onDiagnosticChanged
-- })

-- aucmd('LspAttach', {
--     callback = function(event)
--         local buf = event.buf
--         local client = vim.lsp.get_client_by_id(event.data.client_id)
--         print(client.name, "attached to ", vim.fn.bufname(buf))
--     end
-- })

aucmd("VimResized", {
	command = "wincmd =",
})

aucmd({ "BufEnter", "BufWinEnter", "VimEnter", "WinEnter" }, {
	command = "setlocal cursorline",
})

-- aucmd('User', {
--     pattern = "SessionLoadPost",
--     callback = function()
--         print("SessionLoadPost")
--         local openBufs = {}
--         local allBufs = vim.fn.getbufinfo({bufloaded = 1})
--         for i, entry in ipairs(allBufs) do
--             print("Buf:", entry.bufnr, " ", entry.name, "loaded:", entry.loaded, "listed", entry.listed)
--             if entry.loaded == 1 and entry.listed == 1 then
--                 table.insert(openBufs, entry.name)
--             end
--         end
--         print("All open bufs:", table.concat(openBufs, ", "))
--     end,
-- })

aucmd("WinLeave", {
	command = "setlocal nocursorline",
})
