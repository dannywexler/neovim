Building = 'finished'

local success_text = 'Dec'
local start_text = 'date'
local error_text = 'testerror'

require 'toggleterm'.setup {
    close_on_exit = false,
    direction = 'tab',
    -- float_opts = {
    --     border = 'curved',
    --     height = vim.o.columns * 0.95,
    --     width = vim.o.columns * 0.95,
    -- },
    -- on_exit = function(terminal, job, exit_code, name)
    --     print('on_exit code: ' .. tostring(exit_code))
    -- end,
    on_stderr = function(terminal, job, data, name)
        -- print('stderror')
        Building = 'error'
    end,
    on_stdout = function(terminal, job, data, name)
        for index, value in ipairs(data) do
            -- print('value: ' .. value)
            if value:find(start_text) then
                Building = 'in_progress'
            elseif value:find(success_text) then
                Building = 'finished'
            elseif value:find(error_text) then
                Building = 'error'
            end
        end
    end,
    open_mapping = [[<A-t>]],
    shell = WINDOWS and 'powershell' or 'zsh',
    size = vim.o.columns * 0.3,
    winbar = {
        enabled = true,
        name_formatter = function(term) --  term: Terminal
            return 'TTerminal: ' .. term.name
        end
    },
}
