return {
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = false,
    config = function()
        require 'session_manager'.setup {
            autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
            autosave_ignore_filetypes = {
                'gitcommit',
                'NvimTree'
            },
            autosave_ignore_buftypes = {
                'quickfix',
                'terminal',
            },
        }
    end,
}
