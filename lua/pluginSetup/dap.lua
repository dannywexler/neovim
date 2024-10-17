local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

dap.configurations.java = {
	{
		type = "java",
		request = "attach",
		name = "Debug (Attach) - Remote",
		hostName = "nitesnextctr.mil",
		port = 8787,
	},
}

local keymaps = {
	e = "toggle_breakpoint",
	r = "continue",
	q = "terminate",
	u = "step_over",
	i = "step_into",
	o = "step_out",
}

for key, cmd in pairs(keymaps) do
	local lhs = "<leader>t" .. key
	local rhs = "<CMD>lua require'dap'." .. cmd .. "()<CR>"
	vim.keymap.set("n", lhs, rhs)
end

vim.fn.sign_define(
	"DapBreakpoint",
	{ text = " ", texthl = "", linehl = "", numhl = "" }
)
