-- 快捷键配置
local wezterm = require("wezterm")
local act = wezterm.action
local key = require("utils/keys")
local M = { maximized = true } -- auto maximized when startup

M.config = function(config)
	-- 36 is the default, but you can choose a different size.
	-- Uses the same font as window_frame.font
	config.pane_select_font_size = 36
	-- 配置 leader 键
	-- config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
	config.keys = {
		-- split window
		{ key = "l", mods = "CTRL|ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "k", mods = "CTRL|ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		-- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
		{ key = "8", mods = "CTRL", action = act.PaneSelect },
		-- activate pane selection mode with numeric labels
		{ key = "9", mods = "CTRL", action = act.PaneSelect({ alphabet = "1234567890" }) },
		-- show the pane selection mode, but have it swap the active and selected panes
		{ key = "0", mods = "CTRL", action = act.PaneSelect({ mode = "SwapWithActive" }) },
		-- close current pane
		{ key = "w", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
		-- allow to toggle maximize/normal window
		{
			key = "m",
			mods = "CTRL",
			action = wezterm.action_callback(function(win)
				M.maximized = not M.maximized
				if M.maximized then
					win:maximize()
				else
					win:restore()
				end
			end),
		},
		-- goto up/down/left/right window
		{ key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
		{ key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
		{ key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
		-- adjust pane size
		{ key = "n", mods = "CTRL|ALT|SHIFT", action = act.SpawnWindow },
		{ key = "j", mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Down", 2 }) },
		{ key = "k", mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Up", 2 }) },
		{ key = "h", mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Left", 2 }) },
		{ key = "l", mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
	}

	-- re-source current file
	key.cmd_key(
		"R",
		act.Multiple({
			act.SendKey({ key = "\x1b" }), -- escape
			key.multiple_actions(":source %"),
		})
	)

	-- restart a 4 panes window
	key.cmd_alt_key(
		"4",
		act.Multiple({
			act.SendKey({ key = "\x1b" }), -- escape
			key.multiple_actions(":! wezterm start ~ 4"),
		})
	)
end

return M
