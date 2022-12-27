local diffview = require'diffview'
local fterm = require'FTerm'

local actions = require'diffview.actions'

local function scratchTerm(cmd)
    fterm.scratch({
        cmd = cmd,
        dimensions = {
            height = 0.6,
            width = 0.7,
            y = 0.2,
        }
    })
end

local function getCommitMsg()
    vim.ui.input({
        prompt = 'Commit Message:',
        kind = 'gitcommit'
    },
        function(msg)
            if msg then
                scratchTerm('git commit -m "' .. msg .. '"')
            else
                print('Commit canceled')
            end
        end
    )
end

diffview.setup({
    enhanced_diff_hl = true,
    keymaps = {
        disable_defaults = true,
        file_panel = {
            ['A'] = actions.unstage_all,
            ['a'] = actions.stage_all,
            ['c'] = function() getCommitMsg() end,
            ['f'] = actions.select_entry,
            ['e'] = actions.goto_file_tab,
            ['h'] = actions.scroll_view(-0.2),
            ['i'] = function() scratchTerm('git status') end,
            ['j'] = actions.select_next_entry,
            ['k'] = actions.select_prev_entry,
            ['l'] = actions.scroll_view(0.2),
            ['p'] = function() scratchTerm('git push') end,
            ['r'] = actions.refresh_files,
            ['s'] = actions.toggle_stage_entry,
            ['u'] = function() scratchTerm('git pull') end,
            ['x'] = actions.restore_entry,
        },
        file_history_panel = {
            ['f'] = actions.select_entry,
            ['o'] = actions.options,
            ['h'] = actions.scroll_view(-0.2),
            ['j'] = actions.select_next_entry,
            ['k'] = actions.select_prev_entry,
            ['l'] = actions.scroll_view(0.2),
        }
    },
    view = {
        default = {
            layout = "diff2_horizontal"
        }
    }
})
