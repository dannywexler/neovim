local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
	return
end
local rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

npairs.setup({
	check_ts = true,
	ts_config = {
		lua = { "string", "source" },
		javascript = { "string", "template_string" },
		java = false,
	},
	disable_filetype = { "TelescopePrompt", "spectre_panel" },
	fast_wrap = {
		map = "<M-e>",
		chars = { "{", "[", "(", '"', "'", "<" },
		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
		offset = 0, -- Offset from pattern match
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "PmenuSel",
		highlight_grey = "LineNr",
	},
})

npairs.add_rule(rule("<", ">", {
	-- if you use nvim-ts-autotag, you may want to exclude these filetypes from this rule
	-- so that it doesn't conflict with nvim-ts-autotag
	"-html",
	"-javascriptreact",
	"-typescriptreact",
}):with_pair(
	-- regex will make it so that it will auto-pair on
	-- `a<` but not `a <`
	-- The `:?:?` part makes it also
	-- work on Rust generics like `some_func::<T>()`
	cond.before_regex("%a+:?:?$", 3)
):with_move(function(opts)
	return opts.char == ">"
end))

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end
cmp.event:on(
	"confirm_done",
	cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })
)
