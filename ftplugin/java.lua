if WINDOWS then
    -- local config = {
    --     cmd = {'/path/to/jdt-language-server/bin/jdtls'},
    --     root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    -- }

    local jdtlsPath = vim.fn.stdpath('data') .. '\\mason\\packages\\jdtls\\bin\\jdtls-win.cmd'

    require('jdtls').start_or_attach({
        cmd = {
            jdtlsPath
        },
        root_dir = vim.fn.getcwd()
    })
end
