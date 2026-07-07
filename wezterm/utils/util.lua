local M = {}
local wezterm = require("wezterm")

--- 从数组中随机取一个元素；空数组返回 nil。
M.random_entry = function(entries)
	if #entries == 0 then
		return nil
	end
	local keys = {}
	for key, _ in ipairs(entries) do
		table.insert(keys, key)
	end
	local random_key = keys[math.random(#keys)]
	return entries[random_key]
end

--- 判断路径是否为可读取目录。
M.is_directory = function(path)
	local success, result = pcall(function()
		return wezterm.read_dir(path)
	end)
	return success
end

--- 判断路径是否为可读取文件。
M.is_file = function(path)
	local success, result = pcall(function()
		return wezterm.read_file(path)
	end)
	return success
end

--- 判断路径是否存在。
M.exists = function(path)
	return M.is_directory(path) or M.is_file(path)
end

return M
