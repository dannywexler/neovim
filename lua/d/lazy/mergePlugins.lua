local myPluginConfigPath = 'd.pluginConfigs.'
local mergedPluginSpec = {}
---@type LazySpec[]
local pluginsList = require("d.myPlugins")
---@type string key
for key, config in vim.spairs(pluginsList) do
    ---@type LazySpec
    local spec = { name = tostring(key) }
    if V.isString(config) then
        local userSpec = U.req(myPluginConfigPath .. key) or {}
        spec = U.merge({ config }, spec, userSpec)
    elseif V.isTable(config) then
        spec = U.merge(spec, config)
    end
    if not spec.opts and not spec.config then
        spec = U.merge(spec, { config = true })
    end

    table.insert(mergedPluginSpec, spec)
end

-- P('final mergedPluginSpec', mergedPluginSpec)
return mergedPluginSpec
