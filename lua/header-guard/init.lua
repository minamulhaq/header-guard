local M = {}

local is_valid_c_cpp_file = function(filepath)
	local ext = filepath:match("%.([^.]+)$") -- captures text after last dot
	if ext == "h" or ext == "hpp" then
		return true
	else
		return false
	end
end

M.insert_guard = function(opts)
	-- get full path of current buffer
	local current_file_path = vim.api.nvim_buf_get_name(0)

	if current_file_path == "" then
		print("No files in current buffer")
		return
	end

	if not is_valid_c_cpp_file(current_file_path) then
		vim.notify("Not a valid c/cpp file", vim.log.levels.ERROR)
		return
	end
	-- local parent_dir = vim.fs.basename(vim.fs.dirname(current_file_path))
	-- local current_file_name = vim.fs.basename(current_file_path)
	--
	-- local guard = parent_dir .. "_" .. current_file_name
	-- guard = guard:upper():gsub("[^A-Z0-9]", "_")
	-- guard = "__" .. guard .. "__"
end

vim.api.nvim_create_user_command("Hg", function()
	M.insert_guard()
end, {})

return M
