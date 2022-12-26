-- print('hello from myplugins')

local plugins = {}

local function p(name, url, extraOpts)
    local opts = {
        url,
        name = name,
        config = function()
            local ok, plug = pcall(require, 'pluginSetup.' .. name)
            if not ok then
                print('could not require ' .. name)
            -- else
            --     print('successfully required ' .. name)
            end
        end
    }
    for k, v in pairs(extraOpts or {}) do opts[k] = v end
    table.insert(plugins, opts)
end

p('import', 'miversen33/import.nvim')
p('leap', 'ggandor/leap.nvim')
p('nest', 'LionC/nest.nvim')
p('plenary', 'nvim-lua/plenary.nvim')
p('telescope', 'nvim-telescope/telescope.nvim')
p('tokyonight', 'folke/tokyonight.nvim')
p('winshift', 'sindrets/winshift.nvim')


return plugins
