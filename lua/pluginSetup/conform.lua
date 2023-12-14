local nvim_formatters_folder = vim.fn.stdpath("config") .. "/formatters/"

require("conform").setup({
	formatters = {
		stylua = {
			prepend_args = {
				"--config-path",
				nvim_formatters_folder .. "stylua.toml",
			},
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd" },
	},
})
