if WINDOWS then
	local javaPath = "C:\\bit9prog\\dev\\Java19\\jdk-19.0.2\\bin\\java.exe"
	local jdtlsPath = vim.fn.stdpath("data") .. "\\mason\\packages\\jdtls\\"
	local equinoxLauncher = vim.fn.globpath(
		jdtlsPath .. "plugins",
		"org.eclipse.equinox.launcher_*.jar"
	)

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
end
