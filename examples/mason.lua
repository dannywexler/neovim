--[[
Got this from: NavePnow/dotfiles
M.mason_packages = {
    "bash-language-server",
    "black",
    "clang-format",
    "clangd",
    "codelldb",
    "cspell",
    "css-lsp",
    "eslint-lsp",
    "graphql-language-service-cli",
    "html-lsp",
    "json-lsp",
    "lua-language-server",
    "markdownlint",
    "prettier",
    "pyright",
    "shfmt",
    "stylua",
    "tailwindcss-language-server",
    "taplo",
    "typescript-language-server",
    "yaml-language-server",
    "gopls",
    "editorconfig-checker"
}

M.lsp_servers = {
    "clangd",
    "tsserver",
    "pyright",
    "lua_ls",
    "eslint",
    "bashls",
    "yamlls",
    "jsonls",
    "cssls",
    "taplo",
    "html",
    "graphql",
    "tailwindcss",
    "gopls",
}
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		opts = {
			pip = {
				upgrade_pip = true,
			},
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local utils = require("utils")
			local mr = require("mason-registry")
			local packages = utils.mason_packages
			local function ensure_installed()
				for _, package in ipairs(packages) do
					local p = mr.get_package(package)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
]]
--
