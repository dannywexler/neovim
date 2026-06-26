---@param name string
---@param style? string
---@param fallback string
---@return string
local function env_color(name, style, fallback)
    local key = "MY_COLOR_" .. name:upper()
    if style ~= nil then
        key = key .. "_" .. style:upper()
    end
    local value = vim.env[key]
    if value == nil then
        return fallback
    end
    return value
end

return {
    black = env_color("black", nil, "#000000"),
    blueDark = env_color("blue", "dark", "#004fc7"),
    blueLight = env_color("blue", "light", "#7aa2f7"),
    blueMedium = env_color("blue", "medium", "#0091f8"),
    cyan = env_color("cyan", nil, "#0db9d7"),
    greenDark = env_color("green", "dark", "#1abc9c"),
    greenLight = env_color("green", "Light", "#00fa9a"),
    greyDark = env_color("grey", "dark", "#12131b"),
    greyDim = env_color("grey", "dim", "#292e42"),
    greyLight = env_color("grey", "light", "#b8bdd1"),
    greyMedium = env_color("grey", "medium", "#565c64"),
    orange = env_color("orange", nil, "#e0af68"),
    pink = env_color("pink", nil, "#ff73bd"),
    purple = env_color("purple", nil, "#c678dd"),
    red = env_color("red", nil, "#e06c75"),
    teal = env_color("teal", nil, "#00e5ff"),
    white = env_color("white", nil, "#ffffff"),
    yellow = env_color("yellow", nil, "#eef06d"),
}
