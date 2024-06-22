local code_dir = WINDOWS and "C:\\bit9prog\\dev\\NN\\code" or "~/"
local Path = require("plenary.path")

local cfg = require("session_manager.config")

local utils = require("session_manager.utils")

local myGroup = vim.api.nvim_create_augroup("SessionPicker", { clear = true })
local aucmd = function(event, opts)
	local defaultOpts = { group = myGroup }
	local mergedOpts = vim.tbl_extend("force", defaultOpts, opts)

	vim.api.nvim_create_autocmd(event, mergedOpts)
end

aucmd("VimEnter", {
	callback = function()
		local cwd = vim.loop.cwd()
		if cwd == code_dir then
			-- vim.print(cwd, "matches code dir:", code_dir)
		else
			-- vim.print(cwd, "does not match code dir:", code_dir)
			return
		end

		local all_sessions = utils.get_sessions()

		local filtered_sessions = vim.tbl_filter(function(sess)
			local fname = sess.dir.filename
			-- vim.print(fname)
			if vim.startswith(fname, code_dir) then
				-- vim.print(fname, "startswith", code_dir)
				return true
			end
			return false
		end, all_sessions)

		-- vim.print("found", #filtered_sessions, "matching sessions")
		vim.ui.select(filtered_sessions, {
			prompt = "Load Session",
			format_item = function(item)
				return item.dir.filename
					:gsub(code_dir .. Path.path.sep, "")
					:gsub(Path.path.sep, "/")
			end,
		}, function(item)
			if item then
				-- print("Selected session:", item.dir.filename)
				utils.load_session(item.filename, true)
			end
		end)
	end,
})

require("session_manager").setup({
	autoload_mode = cfg.AutoloadMode.CurrentDir,
	autosave_ignore_filetypes = {
		"gitcommit",
		"NvimTree",
	},
	autosave_ignore_buftypes = {
		-- 'acwrite',
		-- 'nofile',
		-- 'nowrite',
		"quickfix",
		"terminal",
		-- 'prompt',
	},
	autosave_ignore_dirs = {
		code_dir,
	},
})
