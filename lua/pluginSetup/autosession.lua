require 'auto-session'.setup {
    -- the configs below are lua only
    auto_restore_enabled = nil,
    auto_save_enabled = nil,
    auto_session_enable_last_session = false,
    auto_session_enabled = true,
    auto_session_root_dir = vim.fn.stdpath('data') .. "/autosessions/",
    auto_session_suppress_dirs = nil,
    auto_session_use_git_branch = true,
    bypass_session_save_file_types = nil,
    log_level = 'error',
    pre_save_cmds = {'NvimTreeClose'}
}
