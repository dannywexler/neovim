-- print('hello from myplugins')

local plugins = {}

local function p(name, url, extraOpts)
    local opts = {
        url,
        name = name,
        config = function()
            pcall(require, 'pluginSetup.' .. name)
        end
    }
    for k, v in pairs(extraOpts or {}) do opts[k] = v end
    table.insert(plugins, opts)
end

p('import', 'miversen33/import.nvim')
p('tokyonight', 'folke/tokyonight.nvim')
p('winshift', 'sindrets/winshift.nvim')


return plugins
