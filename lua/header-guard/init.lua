local M = {}
local prevalidator = require("header-guard.pre_validator")

local valid_extensions = {
    h = true,
    hpp = true,
}

local is_valid_c_cpp_file = function(filepath)
    local ext = filepath:match("%.([^.]+)$") -- captures text after last dot
    return ext and valid_extensions[ext] or false
end

local insert_guard_in_buffer = function(guardtop, guardend)
    local buf_data = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- Split guard lines
    local top_lines = vim.split(guardtop, "\n", { plain = true })
    local end_lines = vim.split(guardend, "\n", { plain = true })

    -- Combine: top + existing content + bottom
    local new_lines = vim.list_extend(top_lines, buf_data)
    new_lines = vim.list_extend(new_lines, end_lines)

    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
end

M.insert_guard = function()
    -- get full path of current buffer
    local current_file_path = vim.api.nvim_buf_get_name(0)

    if current_file_path == "" then
        vim.notify("No files in current buffer", vim.log.levels.ERROR)
        return
    end

    if not is_valid_c_cpp_file(current_file_path) then
        vim.notify("Not a valid c/cpp file", vim.log.levels.ERROR)
        return
    end

    local parent_dir = vim.fs.basename(vim.fs.dirname(current_file_path))
    local current_file_name = vim.fs.basename(current_file_path)
    local guard = parent_dir .. "_" .. current_file_name
    guard = guard:upper():gsub("[^A-Z0-9]", "_")
    guard = guard .. "__"

    local guard_line_top = "#ifndef " .. guard .. "\n#define " .. guard .. "\n"
    local guard_line_end = "#endif"

    if prevalidator.run_prevalidation(current_file_path) then
        insert_guard_in_buffer(guard_line_top, guard_line_end)
    end
end

M.setup = function(opts)
    opts = opts or {}
end


return M
