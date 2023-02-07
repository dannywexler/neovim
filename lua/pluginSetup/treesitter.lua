local tsconfigs = require 'nvim-treesitter.configs'

local languages = {
    'bash',
    'c',
    'cpp',
    'css',
    'help',
    'html',
    'java',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'regex',
    'tsx',
    'typescript',
    'vim',
    'yaml',
}

tsconfigs.setup {
    additional_vim_regex_highlighting = false,
    autopairs = { enable = true },
    autotag = { enable = true },
    context_commentstring = { enable = true, enable_autocmd = false },
    ensure_installed = languages,
    highlight = {
        enable = true, -- false will disable the whole extension
        -- disable = { "" }, -- list of language that will be disabled
        -- disable = function(lang, buf)
            -- local max_filesize = 1024 * 100 -- 100 KB
            -- -- local max_filesize = 1024 * 1000 -- 100 KB
            -- local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            -- if ok and stats and stats.size > max_filesize then
            --     return true
            -- end
            -- if vim.api.nvim_buf_line_count(buf) > 10000 then
            --     return true
            -- end
        --     return false
        -- end,
    },
    ignore_install = { "" }, -- List of parsers to ignore installing
    indent = { enable = true, disable = { 'yaml' } },
    playground = { enable = true },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
    sync_install = WINDOWS,
    textobjects = {
        -- move = {
        --     goto_previous_start = {
        --         ["<M-k>"] = "@function.outer",
        --     },
        --     goto_next_start = {
        --         ["<M-j>"] = "@function.outer",
        --     },
        -- }
    }
}

require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }
