require 'persisted'.setup {
    autosave = true,
    autoload = true,
    before_save = function()
        vim.cmd('NvimTreeClose')
    end,
    save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/persisted/"),
    silent = true,
    use_git_branch = true
}
