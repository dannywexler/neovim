--[[

if WINDOWS then
	local javaPath = "C:\\bit9prog\\dev\\Java19\\jdk-19.0.2\\bin\\java.exe"
	local jdtlsPath = vim.fn.stdpath("data") .. "\\mason\\packages\\jdtls\\"
	local equinoxLauncher = vim.fn.globpath(
		jdtlsPath .. "plugins",
		"org.eclipse.equinox.launcher_*.jar"
	)

	local bundles = {}

	---
	-- Include java-test bundle if present
	---
	-- local java_test_path =
	-- 	require("mason-registry").get_package("java-test"):get_install_path()
	--
	-- local java_test_bundle = vim.split(
	-- 	vim.fn.glob(java_test_path .. "/extension/server/*.jar"),
	-- 	"\n"
	-- )
	--
	-- if java_test_bundle[1] ~= "" then
	-- 	vim.list_extend(bundles, java_test_bundle)
	-- end

	---
	-- Include java-debug-adapter bundle if present
	---
	local java_debug_path = require("mason-registry")
		.get_package("java-debug-adapter")
		:get_install_path()

	local java_debug_bundle = vim.split(
		vim.fn.glob(
			java_debug_path
				.. "/extension/server/com.microsoft.java.debug.plugin-*.jar"
		),
		"\n"
	)

	if java_debug_bundle[1] ~= "" then
		vim.list_extend(bundles, java_debug_bundle)
	end

	local config = {
		cmd = {
			javaPath,
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base\\java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base\\java.lang=ALL-UNNAMED",
			"-jar",
			equinoxLauncher,
			"-configuration",
			jdtlsPath .. "config_win",
		},
		init_options = {
			bundles = bundles,
		},
		root_dir = require("jdtls.setup").find_root({
			"pom.xml",
			".git",
			"mvnw",
			"gradlew",
		}),
		settings = {
			java = {
				home = "C:\\bit9prog\\dev\\Java19\\jdk-19.0.2",
			},
		},
	}
	require("jdtls").start_or_attach(config)
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()
end

--]]
