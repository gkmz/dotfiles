local wezterm = require("wezterm")
local util = require("utils/util")
local M = {}

M.random_wallpaper = function(dir)
	if not util.is_directory(dir) then
		return {
			source = {
				Color = "#000000",
			},
			height = "Cover",
			width = "Cover",
			horizontal_align = "Center",
			repeat_x = "Repeat",
			repeat_y = "Repeat",
			opacity = 1.0,
			-- speed = 200,
		}
	end
	local wallpapers = {}
	-- read all files in the dir
	for _, v in ipairs(wezterm.glob(dir .. "/**")) do
		if not string.match(v, "%.DS_Store$") then
			table.insert(wallpapers, v)
		end
	end
	local wallpaper = util.random_entry(wallpapers)
	return {
		source = { File = { path = wallpaper } },
		height = "Cover",
		width = "Cover",
		horizontal_align = "Center",
		repeat_x = "Repeat",
		repeat_y = "Repeat",
		opacity = 1.0,
		-- speed = 200,
	}
end

return M