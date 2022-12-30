require 'session_manager'.setup {
    autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
    autosave_ignore_filetypes = {
        'gitcommit',
        'NvimTree'
    },
    autosave_ignore_buftypes = {
        'acwrite',
        'nofile',
        'nowrite',
        'quickfix',
        'terminal',
        'prompt',
    },
}
