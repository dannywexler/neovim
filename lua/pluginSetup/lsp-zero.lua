require('mason.settings').set({
    ui = {
        border = 'rounded'
    }
})

local lsp = require('lsp-zero')

lsp.set_preferences({
    suggest_lsp_servers = true,
    setup_servers_on_start = false,
    set_lsp_keymaps = false,
    configure_diagnostics = false,
    cmp_capabilities = true,
    manage_nvim_cmp = false,
    call_servers = 'local',
    sign_icons = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
    }
})

lsp.ensure_installed({
    "bashls",
    "cssls",
    -- 'jdtls',
    -- 'jsonls',
    'pyright',
    'sumneko_lua',
    'tsserver',
})

lsp.configure('sumneko_lua', {
    diagnostics = {
        globals = { 'import', 'vim', 'WINDOWS' },
    },
    workspace = {
        library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
        },
    },
})

lsp.setup()

vim.diagnostic.config {
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
    -- virtual_text = false,
    virtual_text = {
        format = function(diagnostic)
            -- if diagnostic.severity == vim.diagnostic.severity.ERROR then
            -- return string.format("E: %s", diagnostic.message)
            -- end
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
                return 'ERROR'
            elseif diagnostic.severity == vim.diagnostic.severity.HINT then
                return 'HINT'
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                return 'WARN'
            end
            return diagnostic.message
        end,
        source = false,
    },
}
