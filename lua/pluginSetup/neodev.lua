local function merge(...)
	return vim.tbl_extend("force", ...)
end

local pwshelledsvc = vim.fn.stdpath("data")
	.. "/mason/packages/powershell-editor-services"

---@type lspconfig.options
local servers = {
	biome = {},
	bashls = {},
	cssls = {},
	clangd = {},
	-- jdtls = {},
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "WINDOWS", "P", "U", "V" },
					-- neededFileStatus = {
					--     ["no-unknown"] = "Any!"
					-- }
				},
				telemetry = { enable = false },
				workspace = { checkThirdParty = false },
			},
		},
	},
	powershell_es = {
		shell = "powershell.exe",
		bundle_path = pwshelledsvc,
	},
	tsserver = {
		settings = {
			implicitProjectConfiguration = {
				checkJs = true,
			},
		},
	},
	yamlls = {},
}

require("neodev").setup({
	library = { plugins = { "nvim-dap-ui" }, types = true },
})
require("neoconf").setup({
	plugins = {
		-- configures lsp clients with settings in the following order:
		-- - lua settings passed in lspconfig setup
		-- - global json settings
		-- - local json settings
		lspconfig = {
			enabled = true,
		},
		-- configures jsonls to get completion in .nvim.settings.json files
		jsonls = {
			enabled = true,
			-- only show completion in json settings for configured lsp servers
			configured_servers_only = true,
		},
		-- configures lua_ls to get completion of lspconfig server settings
		lua_ls = {
			-- by default, lua_ls annotations are only enabled in your neovim config directory
			enabled_for_neovim_config = true,
			-- explicitely enable adding annotations. Mostly relevant to put in your local .nvim.settings.json file
			enabled = true,
		},
	},
})
require("mason").setup({
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local defaults = { capabilities = capabilities }

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	automatic_installation = false,
	ensure_installed = vim.tbl_keys(servers),
	handlers = {
		function(server_name)
			-- print("setting up ", server_name)
			local merged = merge(defaults, servers[server_name] or {})
			require("lspconfig")[server_name].setup(merged)
		end,
	},
})
