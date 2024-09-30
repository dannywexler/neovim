vim.opt.termguicolors = true
local fn = vim.fn
local feline = require("feline")
fn.setreg("/", "wxyz")

local function merge(...)
	return vim.tbl_extend("force", ...)
end

local diagnosticIcons = {
	error = " ",
	warn = " ",
	hint = " ",
	info = " ",
}

local myColors = {
	black = "#000000",
	blue = { bright = "#7aa2f7" },
	green = { bright = "#00ffcc", medium = "#1abc9c" },
	grey = { dark = "#1f2335" },
	orange = { bright = "#ff9e64", medium = "#e0af68" },
	purple = { medium = "#c678dd" },
	teal = "#0db9d7",
	red = { bright = "#f55385", medium = "#db4b4b" },
	white = "#ffffff",
}

local winbarColors = {
	active = myColors.green.bright,
	inactive = myColors.blue.bright,
}

local diagnosticColors = {
	error = myColors.red.medium,
	hint = myColors.green.medium,
	info = myColors.teal,
	warn = myColors.orange.bright,
}

local vim_mode_colors = {
	i = myColors.green.medium,
	n = myColors.blue.bright,
	v = myColors.purple.medium,
	V = myColors.purple.medium,
}

local fileTypeMap = {
	DiffviewFiles = " DIFF  ",
	NvimTree = " File Tree 󰙅 ",
	TelescopePrompt = " Telescope  ",
	toggleterm = " TERMINAL  ",
}

-- local spinners = {
--     '•     ',
--     '••    ',
--     '•••   ',
--     ' •••  ',
--     '  ••• ',
--     '   •••',
--     '    ••',
--     '     •',
--     '      ',
-- }
local spinners = {
	"       ",
	"      ",
	"     ",
	"     ",
	"     ",
	"      ",
	"       ",
	"        ",
}
local winbarHighlights = {
	active = {
		fg = myColors.black,
		bg = winbarColors.active,
		style = "bold",
	},
	inactive = {
		fg = myColors.black,
		bg = winbarColors.inactive,
		style = "bold",
	},
}

local windowLetters = {
	"A",
	"S",
	"D",
	"F",
	"G",
}

local Highlights = {
	vi_mode = function()
		return {
			fg = "#000000",
			bg = vim_mode_colors[vim.fn.mode()] or myColors.orange.medium,
			style = "bold",
		}
	end,
	default = function()
		return {
			fg = myColors.white,
			bg = myColors.grey.dark,
		}
	end,
}

local function normalize(sourceString)
	return fn.fnamemodify(sourceString, ":gs?\\?/?")
end

local function getIcon()
	local filename = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	return require("nvim-web-devicons").get_icon_color(filename, extension)
end

local function getTime()
	-- return os.clock()
	return vim.loop.hrtime()
end

local function timeTaken(timerName, startTime)
	-- local ms = (os.clock() - startTime) * 1000
	local ms = (getTime() - startTime) / 1000000
	-- print(('%s took %s ms'):format(timerName, ms))
end

local myCache = {}

local function cacheAFunc(key, getter)
	local function cachedFunction()
		local start = getTime()
		local cacheHit = true
		local buf = vim.fn.bufnr()
		local cacheKey = buf .. "cache" .. key
		local result = myCache[cacheKey]
		if not result then
			cacheHit = false
			result = getter()
			myCache[cacheKey] = result
		end

		-- local cacheSuccess = cacheHit and 'hit' or 'miss'
		-- if not cacheHit then
		--     print(('Cache %s getting %s for buf %s. Got: %s'):format(cacheSuccess, key, buf, result))
		-- end
		timeTaken("cached " .. key, start)
		return result
	end
	return cachedFunction
end

local function cacheFuncs(funcsToCache)
	local cachedFuncs = {}
	for funcName, funcBody in pairs(funcsToCache) do
		-- print('caching ' .. funcName)
		cachedFuncs[funcName] = cacheAFunc(funcName, funcBody)
	end
	return cachedFuncs
end

local CachedFuncs = cacheFuncs({
	getFolder = function()
		return normalize(fn.fnamemodify(fn.getcwd(), ":~"))
	end,
	getParentPath = function()
		-- print("getting parentPath for buf:", fn.bufnr())
		return normalize(fn.fnamemodify(fn.getcwd(), ":~:h"))
	end,
	getCwd = function()
		return fn.fnamemodify(fn.getcwd(), ":t")
	end,
})

local Funcs = {
	getFileRelativePath = function()
		local relativePath = normalize(fn.expand("%:.:h"))
		if relativePath == "." then
			return ""
		end
		return relativePath
	end,
	getFileName = function()
		-- print("getting filename for buf:", fn.bufnr())
		return fileTypeMap[vim.bo.filetype] or fn.expand("%:t")
	end,
	getWinbarFileName = function()
		local startTime = getTime()
		-- print('getting winbar filename for buf ' .. fn.bufnr() .. ' ' .. os.date('%S'))
		local fileName = fn.expand("%:t")
		if fileName == "NvimTree_1" then
			return normalize(fn.fnamemodify(fn.getcwd(), ":~"))
		end
		-- if fileName:find('toggleterm') then
		--     return 'TERMINAL  '
		-- end
		timeTaken("original getWinbarFileName", startTime)
		return fileName
	end,
	lineAndCol = function()
		local currentLine = vim.fn.line(".")
		local totalLines = vim.fn.line("$")
		local currentCol = vim.fn.col(".")
		return (" %3s/%s | %3s "):format(currentLine, totalLines, currentCol)
		-- return (' C: %3s  L: %3s/%s '):format(currentCol, currentLine, totalLines)
	end,
	getBuildStatus = function()
		local result = BuildStatus
		if BuildStatus == "finished" then
			result = "Build finished"
		elseif BuildStatus == "in_progress" then
			result = "Building " .. spinners[os.date("%S") % #spinners + 1]
		end
		return result .. " "
	end,
	getDiagnostics = function(_, opts)
		local level = opts.level
		-- print('getting diagnostics for level:', level, 'for buf:', fn.bufnr())
		local severity = vim.diagnostic.severity[level:upper()]
		local count =
			vim.tbl_count(vim.diagnostic.get(0, { severity = severity }))
		if count == 0 then
			return ""
		end
		return (" %s %s"):format(count, diagnosticIcons[level])
	end,
	getFileIcon = function()
		local icon = getIcon() or ""
		return icon .. " "
	end,
	getFileIconColor = function()
		local _, color = getIcon()
		return color or myColors.white
	end,
	formatSearchResults = function()
		local searchText = fn.getreg("/")
		if searchText == "wxyz" then
			return ""
		end
		if
			vim.startswith(searchText, "\\<")
			and vim.endswith(searchText, "\\>")
		then
			searchText = searchText:sub(3, #searchText - 2)
		end
		local searchCount = fn.searchcount({ maxcount = 0 })
		-- return ('%s match %2s of %s'):format(searchText, searchCount.current, searchCount.total)
		return ("%s match %2s/%s"):format(
			searchText,
			searchCount.current,
			searchCount.total
		)
	end,
	-- navic = function()
	-- 	return "  " .. require("nvim-navic").get_location()
	-- end,
	vimMode = function()
		return vim.fn.mode():sub(1, 1):upper()
	end,
	windowLetter = function()
		local winNumber = vim.api.nvim_win_get_number(0)
		if winNumber == nil then
			return ""
		end
		local winLetter = windowLetters[winNumber]
		if winLetter == nil then
			return ""
		end
		return "  " .. winLetter .. "  "
	end,
}

local function sideifyAComp(compConfig, leftOrRight, toRound)
	-- print('sideifyAComp', toRound)
	local spacer = { str = " ", hl = Highlights.default }
	local sideConfig = {}
	if toRound then
		sideConfig.hl = Highlights.vi_mode
		if leftOrRight == "left" then
			sideConfig = {
				left_sep = "left_rounded",
				right_sep = { "right_rounded", spacer },
			}
		else
			sideConfig = {
				left_sep = { spacer, "left_rounded" },
				right_sep = "right_rounded",
			}
		end
	else
		if leftOrRight == "left" then
			sideConfig = { right_sep = spacer }
		else
			sideConfig = { left_sep = spacer }
		end
	end
	local mergedConfig = merge(compConfig, sideConfig)
	-- print("merged config:", vim.inspect(mergedConfig))
	return mergedConfig
end

local function takeASide(compConfigTable, leftOrRight)
	local mergedTable = {}
	for _, compConfig in ipairs(compConfigTable) do
		local newComp = compConfig
		if compConfig.rounded then
			newComp.hl = Highlights.vi_mode
			newComp = sideifyAComp(newComp, leftOrRight, true)
		else
			newComp = sideifyAComp(newComp, leftOrRight, false)
		end
		table.insert(mergedTable, newComp)
	end
	-- print('takeASide mergedTable', vim.inspect(mergedTable))
	return mergedTable
end

local Comps = {
	buildStatus = {
		provider = "getBuildStatus",
		hl = function()
			local fgColor = myColors.red.bright

			if BuildStatus == "finished" then
				fgColor = myColors.green.medium
			elseif BuildStatus == "in_progress" then
				fgColor = myColors.orange.bright
			end

			return {
				fg = fgColor,
				-- bg = '#000000',
			}
		end,
		enabled = function()
			return WINDOWS
				and fn.getcwd():find("bit9prog")
				and fn.getcwd():find("code")
		end,
	},
	diagComp = function(severity)
		return {
			provider = {
				name = "getDiagnostics",
				opts = { level = severity },
				-- update = { 'DiagnosticChanged' }
				update = { "CursorHold" },
			},
			hl = {
				fg = diagnosticColors[severity],
				bg = myColors.grey.dark,
				style = "bold",
			},
		}
	end,
	gap = function(hl)
		return {
			provider = " ",
			hl = hl or Highlights.default,
		}
	end,
	getParentPath = {
		provider = {
			name = "getParentPath",
			update = { "VimEnter", "SessionLoadPost" },
		},
		rounded = true,
		hl = {
			style = "bold",
		},
	},
	getCwd = {
		provider = {
			name = "getCwd",
			update = { "VimEnter", "SessionLoadPost" },
		},
		rounded = true,
		hl = {
			style = "bold",
		},
	},
	getFileRelativePath = {
		provider = { name = "getFileRelativePath", update = { "BufEnter" } },
		rounded = true,
		hl = {
			style = "bold",
		},
	},
	getFileIcon = {
		provider = { name = "getFileIcon", update = { "BufEnter" } },
		hl = function()
			return {
				fg = Funcs.getFileIconColor(),
			}
		end,
		enabled = function()
			return #vim.bo.buftype == 0
		end,
	},
	getFileName = {
		provider = { name = "getFileName", update = { "BufEnter" } },
		hl = {
			style = "bold",
		},
	},
	-- navic = {
	-- 	provider = "navic",
	-- 	enabled = require("nvim-navic").is_available,
	-- 	hl = {
	-- 		bg = myColors.grey.dark,
	-- 	},
	-- },
	searchResults = {
		provider = "formatSearchResults",
		rounded = true,
	},
	vimMode = {
		provider = { name = "vimMode", update = { "ModeChanged" } },
		rounded = true,
	},
	windowLetter = {
		provider = {
			name = "windowLetter",
			update = { "WinEnter", "WinLeave" },
		},
	},
}

local activeLeft = {
	Comps.getParentPath,
	Comps.getCwd,
	Comps.getFileRelativePath,
	Comps.getFileIcon,
	Comps.getFileName,
	-- Comps.navic,
}

local activeRight = {
	Comps.buildStatus,
	Comps.searchResults,
	Comps.vimMode,
}

local inactiveLeft = {
	Comps.getParentPath,
	Comps.getCwd,
	Comps.getFileName,
}

-- local testCompResult = colorifyAComp

feline.setup({
	default_bg = myColors.grey.dark,
	default_fg = myColors.white,
	components = {
		active = {
			takeASide(activeLeft, "left"),
			takeASide(activeRight, "right"),
		},
		inactive = {
			takeASide(inactiveLeft, "left"),
		},
	},
	custom_providers = merge(CachedFuncs, Funcs),
	force_inactive = {
		filetypes = {
			"^NvimTree$",
			"^toggleterm$",
			"^DiffviewFiles$",
			"^TelescopePrompt$",
		},
	},
	separators = {
		right_sep = "right_rounded",
		left_sep = "left_rounded",
	},
	theme = {
		fg = myColors.white,
		bg = myColors.grey.dark,
	},
})

-- WINBAR CONFIG BELOW HERE:

local function winbarComps(tive)
	return {
		{
			Comps.gap(winbarHighlights[tive]),
			{
				-- provider = 'getFileIcon',
				provider = { name = "getFileIcon", update = { "BufEnter" } },
				hl = winbarHighlights[tive],
				enabled = function()
					return #vim.bo.buftype == 0
				end,
			},
			Comps.gap(winbarHighlights[tive]),
			{
				provider = {
					name = "getWinbarFileName",
					update = { "BufEnter" },
				},
				hl = winbarHighlights[tive],
			},
			Comps.gap(winbarHighlights[tive]),
			Comps.gap(winbarHighlights[tive]),
			{
				provider = "",
				hl = {
					fg = myColors.grey.dark,
					bg = winbarColors[tive],
				},
				enabled = require("feline.providers.lsp").diagnostics_exist,
			},
			Comps.diagComp("error"),
			Comps.diagComp("warn"),
			Comps.diagComp("info"),
			Comps.diagComp("hint"),
			{
				provider = "",
				hl = {
					fg = myColors.grey.dark,
					bg = winbarColors[tive],
				},
				enabled = require("feline.providers.lsp").diagnostics_exist,
			},
			Comps.gap(winbarHighlights[tive]),
			{
				provider = "windowLetter",
				hl = winbarHighlights[tive],
			},
		},
		{
			{
				provider = "lineAndCol",
				hl = winbarHighlights[tive],
				enabled = function()
					local buftype = vim.bo.buftype
					return buftype == "help" or #vim.bo.buftype == 0
				end,
			},
		},
	}
end

feline.winbar.setup({
	components = {
		active = winbarComps("active"),
		inactive = winbarComps("inactive"),
	},
	disable = {
		buftypes = {
			"^terminal$",
		},
		filetypes = {
			"^toggleterm$",
		},
	},
})
