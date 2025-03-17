local M = {}

M.random_entry = function(entries)
	local keys = {}
	for key, _ in ipairs(entries) do
		table.insert(keys, key)
	end
	local random_key = keys[math.random(#keys)]
	return entries[random_key]
end

return M
