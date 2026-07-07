-- -- 快捷键配置
local wezterm = require("wezterm")
local act = wezterm.action
local key = require("utils/keys")
local layout = require("layout")
local M = { maximized = true } -- auto maximized when startup

local half_zoom_states = {}
local opposite_direction = {
	Up = "Down",
	Down = "Up",
}

-- 向主配置追加一个快捷键，避免辅助函数返回值被静默丢弃。
local function append_key(config, binding)
	table.insert(config.keys, binding)
end

-- 从当前 pane 获取工作目录，让新布局窗口默认继承当前项目路径。
local function get_pane_cwd(pane)
	local cwd = pane:get_current_working_dir()
	local ok, file_path = pcall(function()
		return cwd and cwd.file_path
	end)

	if ok and file_path then
		return file_path
	end

	if type(cwd) == "string" then
		return cwd:gsub("^file://localhost", ""):gsub("^file://", "")
	end

	return wezterm.home_dir
end

-- 打开指定数量 pane 的新窗口，并应用 layout.lua 中定义的固定布局。
local function spawn_pane_layout(pane_count)
	return wezterm.action_callback(function(_, pane)
		layout.spawn_pane_layout(pane_count, get_pane_cwd(pane))
	end)
end

-- 获取当前 tab 的整体高度，用于把 pane 临时扩到所在列的完整高度。
local function get_tab_cell_height(panes)
	local bottom = 0

	for _, info in ipairs(panes) do
		bottom = math.max(bottom, info.top + info.height)
	end

	return bottom
end

-- 从 panes_with_info 结果中找出当前活动 pane 的布局信息。
local function get_active_pane_info(panes, pane)
	local pane_id = pane:pane_id()

	for _, info in ipairs(panes) do
		if info.pane:pane_id() == pane_id then
			return info
		end
	end

	return nil
end

-- 计算列内高度放大的方向和距离，让当前 pane 高度临时占满整列。
local function plan_column_height_zoom(active_pane, tab_height)
	local plan = {
		direction = "Up",
		amount = active_pane.top,
		original_height = active_pane.height,
		original_top = active_pane.top,
	}

	if plan.amount <= 0 then
		plan = {
			direction = "Down",
			amount = tab_height - active_pane.top - active_pane.height,
			original_height = active_pane.height,
			original_top = active_pane.top,
		}
	end

	if plan.amount <= 0 then
		return nil
	end

	return plan
end

-- 根据当前实际尺寸计算恢复距离，避免 WezTerm 最小 pane 高度导致还原过头。
local function plan_column_height_restore(state, active_pane)
	if state.direction == "Up" then
		return {
			direction = opposite_direction[state.direction],
			amount = state.original_top - active_pane.top,
		}
	end

	return {
		direction = opposite_direction[state.direction],
		amount = active_pane.height - state.original_height,
	}
end

-- 临时把当前 pane 高度放大到所在列的 100%；再次按下时执行反向 resize 尽量恢复原布局。
local function toggle_half_pane_zoom()
	return wezterm.action_callback(function(window, pane)
		local pane_id = pane:pane_id()
		local state = half_zoom_states[pane_id]
		local panes = pane:tab():panes_with_info()
		local active_pane = get_active_pane_info(panes, pane)

		if state then
			local restore_plan = active_pane and plan_column_height_restore(state, active_pane)
				or { direction = opposite_direction[state.direction], amount = state.amount }
			if restore_plan.amount > 0 then
				window:perform_action(act.AdjustPaneSize({ restore_plan.direction, restore_plan.amount }), pane)
			end
			half_zoom_states[pane_id] = nil
			return
		end

		if not active_pane then
			return
		end

		local tab_height = get_tab_cell_height(panes)
		local plan = plan_column_height_zoom(active_pane, tab_height)
		if not plan then
			return
		end

		half_zoom_states[pane_id] = plan
		window:perform_action(act.AdjustPaneSize({ plan.direction, plan.amount }), pane)
	end)
end

--- 配置终端分屏、窗格导航和常用编辑器快捷键。
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
		-- 临时把当前 pane 高度放大到所在列的 100%，再次按下恢复。
		{ key = "z", mods = "CTRL|ALT", action = toggle_half_pane_zoom() },
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
	append_key(
		config,
		key.cmd_key(
			"R",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				key.multiple_actions(":source %"),
			})
		)
	)

	-- 按固定布局打开多 pane 新窗口。
	for _, pane_count in ipairs({ 3, 4, 5, 6 }) do
		append_key(config, key.cmd_alt_key(tostring(pane_count), spawn_pane_layout(pane_count)))
	end
end

return M
