BuildStatus = 'finished'

local start_text = 'MAVEN_OPTS'
local success_text = 'All wars successfully redeployed'
local error_messages = {
    'testerror',
    'Maven build error - no wars redeployed',
    'BUILD FAILURE',
    'No wars found in current directory',
    'Could not transfer',
    'failed to deploy',
    'All wars failed to redeploy',
}

require 'toggleterm'.setup {
    close_on_exit = false,
    direction = 'tab',
    float_opts = {
        border = 'curved',
        height = vim.o.lines - 8,
        width = vim.o.columns - 8,
    },
    -- on_exit = function(terminal, job, exit_code, name)
    --     print('on_exit code: ' .. tostring(exit_code))
    -- end,
    on_stderr = function(terminal, job, data, name)
        -- print('stderror')
        BuildStatus = 'error'
    end,
    on_stdout = function(terminal, job, data, name)
        for _, output in ipairs(data) do
            -- print('output: ' .. output)
            if output:find(start_text) then
                BuildStatus = 'in_progress'
                return
            elseif output:find(success_text) then
                BuildStatus = 'finished'
                return
            end

            for _, error_message in ipairs(error_messages) do
                if output:find(error_message) then
                    BuildStatus = error_message
                    return
                end
            end
        end
    end,
    open_mapping = [[<C-t>]],
    shell = WINDOWS and 'powershell' or 'zsh',
    size = vim.o.columns * 0.3,
    winbar = {
        enabled = false,
        name_formatter = function(term) --  term: Terminal
            return 'TTerminal: ' .. term.name
        end
    },
}
