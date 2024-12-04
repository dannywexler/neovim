require("colorizer").setup({
    filetypes = {
        css = {
            names = true
        },
        "html",
        "lua",
        "javascript"
    },
	user_default_options = {
		names = false,
		mode = "virtualtext",
		-- virtualtext = '■■■■■■■'
		virtualtext = "      ",
	},
})
