local M = {}

local valid_extensions = {
	h = true,
	hpp = true,
}

local is_valid_c_cpp_file = function(filepath)
	local ext = filepath:match("%.([^.]+)$") -- captures text after last dot
	return ext and valid_extensions[ext] or false
end

local insert_guard_in_buffer = function(guardtop, guardend)
	print("Guard is\n" .. guardtop .. guardend)

	-- get buffer content
	local buf_data = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	-- join lines into single string
	local full_text = table.concat(buf_data, "\n")

	-- build guarded text
	local guarded_text = guardtop .. "\n" .. full_text .. "\n" .. guardend

	-- split back into lines
	local new_lines = {}
	for line in guarded_text:gmatch("([^\n]*)\n?") do
		table.insert(new_lines, line)
	end

	-- overwrite buffer with new lines
	vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
end

M.insert_guard = function(opts)
	-- get full path of current buffer
	local current_file_path = vim.api.nvim_buf_get_name(0)
	print("Current file: " .. current_file_path)

	if current_file_path == "" then
		print("No files in current buffer")
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
	guard = "__" .. guard .. "__"

	guard_line_top = "#ifndef " .. guard .. "\n#define " .. guard .. "\n"
	guard_line_end = "#endif"

	insert_guard_in_buffer(guard_line_top, guard_line_end)
end

vim.api.nvim_create_user_command("Hg", function()
	M.insert_guard()
end, {})

return M
