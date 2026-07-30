return PLUG("mfussenegger/nvim-jdtls", {
    main = "jdtls",
    ft = "java",
    config = function()
        local data_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "jdtls", "data")

        require("jdtls").start_or_attach({
            cmd = {
                "jdtls",
                "-data",
                data_dir,
                "--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false",
                "-Xmx8G",
            }
        })
    end
})
