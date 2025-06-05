local formatted_files = {}
local hello = "world"
local files_map = {}

local function on_fd_result(fd_res)
    local fmodify = vim.fn.fnamemodify
    local longest_filename = 12
    local file_info = {}
    for file in fd_res.stdout:gmatch("[^\n]+") do
        local normalized = fmodify(file, ":gs?\\?/?")
        local relative_path = fmodify(normalized, ":h")
        if relative_path == "." then relative_path = "" end
        local file_name = fmodify(normalized, ":t")
        local file_name_length = #file_name
        if (file_name_length > longest_filename) then
            longest_filename = file_name_length
        end
        local icon = require("mini.icons").get("file", file_name) .. " "
        table.insert(file_info, {
            icon = icon,
            relative_path = relative_path,
            name = file_name,
            path = normalized
        })
    end
    local fmt_string = "%s %-" .. (longest_filename + 1) .. "s %s"
    for _, rel_info in ipairs(file_info) do
        local formatted = fmt_string:format(
            rel_info.icon,
            rel_info.name,
            rel_info.relative_path)
        table.insert(formatted_files, formatted)
        files_map[formatted] = rel_info.path
    end
end

local function refresh()
    vim.system({ "fd", "-t", "f" }, {}, vim.schedule_wrap(on_fd_result))
end

local function setup()
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = refresh
    })
end

local function find()
    vim.ui.select(formatted_files, { prompt = "Choose File" }, vim.schedule_wrap(function(choice)
        if not choice then
            return vim.notify("No file chosen.", vim.log.levels.WARN)
        end
        local full_path = files_map[choice]
        assert(full_path, "Missing full_path for formatted path:" .. choice)
        vim.cmd.e(full_path)
    end))
end

return {
    find = find,
    refresh = refresh,
    setup = setup,
}
