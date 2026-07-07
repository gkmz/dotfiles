-- =========================================
-- 字体配置
-- =========================================

local wezterm = require("wezterm")
local M = {}

--- 配置终端字体、字号和行高。
M.config = function(config)
	-- 显式加入用户字体目录，避免 WezTerm CLI/CoreText 扫描不到手动安装的 Nerd Font。
	config.font_dirs = {
		wezterm.home_dir .. "/Library/Fonts",
		wezterm.home_dir .. "/Library/Fonts/ComicShannsMono",
	}
	config.font = wezterm.font_with_fallback({
		{
			family = "ComicShannsMono Nerd Font",
			weight = "Bold",
			italic = false,
			scale = 1.0,
		},
		{
			family = "Heiti SC",
			weight = "Medium",
			scale = 1.0,
		},
		{ family = "Monaco", weight = "Regular", italic = false, scale = 1.0 },
	})
	config.font_size = 16.0
	config.line_height = 1.4
end

return M
