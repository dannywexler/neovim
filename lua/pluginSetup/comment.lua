require 'Comment'.setup {
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    toggler = {
        -- line = '<A-c>'
        line = 'm'
    }
}
