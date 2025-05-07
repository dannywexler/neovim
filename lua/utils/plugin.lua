---@class PluginSpec
---@field branch string? Branch of the repository.
---@field build string? Build is executed when a plugin is installed or updated.
---@field cmd (string | string[])? Lazy-load on command.
---@field cond (boolean | fun():boolean)? Behaves the same as enabled, but won't uninstall the plugin when the condition is false. Useful to disable some plugins in vscode, or firenvim for example.
---@field dependencies table? A list of plugin names or plugin specs that should be loaded when the plugin loads.
---@field enabled (boolean | fun():boolean)? When false, or if the function returns false, then this plugin will not be included in the spec.
---@field event (string | string[])? Lazy-load on event. Events can be specified as BufEnter or with a pattern like BufEnter *.lua
---@field ft (string | string[])? Lazy-load on filetype.
---@field init fun(plugin: table)? Init functions are always executed during startup. Mostly useful for setting vim.g.* configuration used by Vim plugins startup
---@field lazy boolean? When true, the plugin will only be loaded when needed. Lazy-loaded plugins are automatically loaded when their Lua modules are required, or when one of the lazy-loading handlers triggers
---@field main string? Can specify the main module in case it can not be determined automatically.
---@field opts (table | fun(opts:table):table)? Opts should be a table (will be merged with parent specs), return a table (replaces parent specs) or should change a table.
---@field priority? number Only useful for start plugins (lazy=false) to force loading certain plugins first. Default priority is 50. It's recommended to set this to a high number for colorschemes.
---@field version (string | boolean)? Version to use from the repository. Full Semver ranges are supported


---@class LazySpec : PluginSpec
---@field name string Name of the plugin used for the local plugin directory and as the display name.
---@field opts (table | fun(plugin:table, opts:table):table)
---@field url string

local piecesToRemove = {
    '^Nvim',
    '^nvim',
    '^Vim',
    '^vim',
    'Nvim$',
    'nvim$',
    'Vim$',
    'vim$',
    '%.lua$',
    '^[^%a%d]',
    '[^%a%d]$',
}


---Removes all patterns from sourceString
---@param sourceString string
---@param patternsToRemove string[]
local function removeAll(sourceString, patternsToRemove)
    for _, patternToRemove in ipairs(patternsToRemove) do
        sourceString = sourceString:gsub(patternToRemove, '')
    end
    return sourceString
end

---Normalizes pluginName
---@param pluginURL string
local function normalize(pluginURL)
    -- print('normalizing: ' .. pluginURL)
    local user = removeAll(pluginURL, { '/(.*)$' })
    local repo = removeAll(pluginURL, { '^(.*)/' })

    local normalizedPluginName = removeAll(repo, piecesToRemove)
    if vim.tbl_contains({ 'nvim', 'vim', 'neovim' }, repo) then
        normalizedPluginName = user
    end
    return normalizedPluginName:gsub('[^%a%d]', '_')
end

---Sets up a lazy plugin after normalizing the name
---@param pluginURL string the plugin url in owner/repo format
---@param spec PluginSpec?
---@return LazySpec
local function plug(pluginURL, spec)
    return require("utils.merge")(
        { opts = {} },
        spec,
        {
            name = normalize(pluginURL),
            url = "https://github.com/" .. pluginURL,
        })
end

return plug
