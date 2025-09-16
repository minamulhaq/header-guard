-- Fixed version with corrections highlighted:
local M = {}

local function read_file_lines(filepath)
    local lines = {}
    local f = io.open(filepath, "r")
    if not f then
        return nil, "Cannot open file: " .. filepath
    end
    for line in f:lines() do
        table.insert(lines, line)
    end
    f:close()
    return lines
end

local function get_validation(lines)
    print("Total lines read from file: " .. #lines)
    if #lines < 3 then
        print("Empty file... detected")
        return true
    end

    for i = 1, #lines do
        print(lines[i])
    end
    return true
end

function M.run_prevalidation(filepath)
    print("Processing filepath: " .. filepath)
    local lines, err = read_file_lines(filepath)
    if not lines then
        if vim and vim.notify then
            vim.notify("" .. err, vim.log.levels.ERROR, {})
        else
            print("Error: " .. err)
        end
        return false
    end
    return get_validation(lines)
end

return M
