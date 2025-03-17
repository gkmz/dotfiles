-- =========================================
-- 字体配置
-- =========================================

local wezterm = require("wezterm")
local M = {}

M.config = function(config)
	config.font = wezterm.font_with_fallback({
    {
      family = "ComicShannsMono Nerd Font",
      weight = 510,
      italic = false,
      stretch = "Expanded",
      scale = 1.0,
    },
		{
			family = "JetBrainsMono Nerd Font",
			weight = 520,
			italic = false,
			stretch = "Expanded",
			scale = 1.0,
		},
		{ family = "Hannotate SC", weight = 550, stretch = "Expanded", scale = 1.0 },
		{ family = "Hei", weight = 550, stretch = "Expanded", scale = 1.0 },
		{ family = "Monaco", weight = 500, italic = false, stretch = "Expanded", scale = 1.0 },
	})
	config.font_size = 13.0
	config.line_height = 1.4
end

return M
