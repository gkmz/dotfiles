local wezterm = require("wezterm")
local util = require("utils/util")
local M = {}

-- 生成纯色背景，作为壁纸目录不存在或为空时的兜底方案。
local function solid_background(opacity)
	return {
		source = {
			Color = "#000000",
		},
		height = "Cover",
		width = "Cover",
		horizontal_align = "Center",
		repeat_x = "Repeat",
		repeat_y = "Repeat",
		opacity = opacity,
		-- speed = 200,
	}
end

--- 从目录中随机选择一张壁纸；目录不存在、为空或只有非文件项时回退为纯色背景。
M.random_wallpaper = function(dir)
	if not util.is_directory(dir) then
		return solid_background(1.0)
	end
	local wallpapers = {}
	-- read all files in the dir
	for _, v in ipairs(wezterm.glob(dir .. "/**")) do
		if not string.match(v, "%.DS_Store$") and util.is_file(v) then
			table.insert(wallpapers, v)
		end
	end
	local wallpaper = util.random_entry(wallpapers)
	if not wallpaper then
		return solid_background(1.0)
	end
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
