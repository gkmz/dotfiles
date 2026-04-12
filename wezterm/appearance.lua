local wezterm = require("wezterm")
local wallpaper = require("utils/wallpaper")
local M = {}

M.config = function(config)
	-- =========================================
	-- 主题配置
	-- =========================================

	config.color_scheme = "tokyonight_moon"
	-- config.color_scheme = "tokyonight_night"

	-- =========================================
	-- 窗口配置
	-- =========================================

	config.macos_window_background_blur = 10
	config.native_macos_fullscreen_mode = false
	config.adjust_window_size_when_changing_font_size = false
	config.debug_key_events = false
	-- config.window_decorations = "RESIZE" -- 配置窗口是否有标题栏和/或可调整大小的边框
	config.enable_scroll_bar = false
	config.tab_bar_at_bottom = false
	config.enable_tab_bar = false -- 去掉tabbar
	config.hide_tab_bar_if_only_one_tab = true -- 如果只有一个 tab 则隐藏tabbar
	config.use_fancy_tab_bar = false
	config.tab_max_width = 26

	config.background = {
		-- wallpaper.random_wallpaper(os.getenv("HOME") .. "/.config/wezterm/wallpapers/"),
		{
			source = {
				-- Color = "#222436",
				Color = "#000000",
			},
			width = "100%",
			height = "100%",
			opacity = 0.8,
		},
	}

	-- 窗口padding
	config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

	config.window_frame = {
		font = config.font,
		font_size = config.font_size,
	}

	wezterm.on("window-config-reloaded", function(window, pane)
		window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
	end)

	-- =========================================
	-- Performance
	-- =========================================

	config.max_fps = 24
	config.animation_fps = 0
	config.cursor_blink_ease_in = "Constant"
	config.cursor_blink_ease_out = "Constant"

	config.use_resize_increments = false
end

-- =========================================
-- Support neovim Zen mode
-- =========================================

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}

	if name == "T_SESSION" then
		local session = value
		wezterm.log_info("is session", session)
		overrides.background = {
			window.set_tmux_session_wallpaper(value),
			{
				source = {
					Gradient = {
						colors = { "#000000" },
					},
				},
				width = "100%",
				height = "100%",
				opacity = 0.85,
			},
		}
	end

	if name == "ZEN_MODE" then
		-- zenmod will use wezterm plugin to increase font size when start zenmod
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			-- reset font size when quit zenmode
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			-- if no +fontsize configurated, process as absolute font size
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

return M
