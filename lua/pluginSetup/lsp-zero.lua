require("mason.settings").set({
	max_concurrent_installers = WINDOWS and 1 or 4,
	ui = {
		border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("neodev").setup({
	lspconfig = true,
})

local lsp = require("lsp-zero")
local navic = require("nvim-navic")
local util = require("lspconfig.util")

lsp.set_preferences({
	suggest_lsp_servers = true,
	setup_servers_on_start = true,
	set_lsp_keymaps = false,
	configure_diagnostics = false,
	cmp_capabilities = true,
	manage_nvim_cmp = false,
	call_servers = "local",
	sign_icons = {
		error = "✘",
		warn = "▲",
		hint = "⚑",
		info = "",
	},
})

lsp.ensure_installed({
	"bashls",
	"cssls",
	"jdtls",
	"jsonls",
	"marksman",
	"pyright",
	-- 'nimls',
	"rust_analyzer",
	"lua_ls",
	"svelte",
	"tsserver",
	"yamlls",
	-- 'tailwindcss'
})

lsp.set_server_config({
	single_file_support = true,
	flags = { debounce_text_changes = 300 },
})

lsp.on_attach(function(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
end)

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lsp.configure("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

lsp.configure("lua_ls", {
	commands = {
		Format = {
			function()
				require("stylua-nvim").format_file()
			end,
		},
	},
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "WINDOWS" },
			},
			runtime = {
				path = runtime_path,
				version = "LuaJIT",
			},
			telemetry = {
				enable = false,
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
				-- library = {
				--     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
				--     [vim.fn.stdpath("config") .. "/lua"] = true,
				-- },
			},
		},
	},
})

lsp.configure("tsserver", {
	settings = {
		implicitProjectConfiguration = {
			checkJs = true,
		},
	},
})

lsp.nvim_workspace()
lsp.setup()

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
