local M = {}
local wezterm = require("wezterm")

M.random_entry = function(entries)
	local keys = {}
	for key, _ in ipairs(entries) do
		table.insert(keys, key)
	end
	local random_key = keys[math.random(#keys)]
	return entries[random_key]
end

M.is_directory = function(path)
	local success, result = pcall(function()
		return wezterm.read_dir(path)
	end)
	return success
end

M.is_file = function(path)
	local success, result = pcall(function()
		return wezterm.read_file(path)
	end)
	return success
end

M.exists = function(path)
	return M.is_directory(path) or M.is_file(path)
end

return M
