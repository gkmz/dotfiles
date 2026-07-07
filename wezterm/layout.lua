local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local M = {}

-- 判断参数是否为纯数字，避免把带数字的项目路径误判为窗格数量。
local function is_pane_count(value)
	return type(value) == "string" and value:match("^%d+$") ~= nil
end

-- 解析 `wezterm start [目录] [窗格数]` 或 `wezterm start [窗格数]` 启动参数。
local function parse_startup_args(cmd)
	local project_dir = wezterm.home_dir
	local args = {}
	local pane_cnt = 1

	if not cmd then
		return project_dir, args, pane_cnt
	end

	if #cmd.args >= 1 then
		if is_pane_count(cmd.args[1]) then
			pane_cnt = math.floor(tonumber(cmd.args[1]))
		else
			project_dir = cmd.args[1]
		end
	end

	if #cmd.args == 2 and is_pane_count(cmd.args[2]) then
		pane_cnt = math.floor(tonumber(cmd.args[2]))
	end

	return project_dir, args, math.max(pane_cnt, 1)
end

-- 将指定列拆成上下两个等高窗格。
local function split_column_vertically(pane, project_dir)
	pane:split({
		direction = "Top",
		size = 0.5,
		cwd = project_dir,
	})
end

-- 创建左右两列布局，左列和右列各占一半宽度。
local function split_two_columns(pane, project_dir)
	return pane:split({
		direction = "Left",
		size = 0.5,
		cwd = project_dir,
	}), pane
end

-- 创建左中右三列布局，每列各占三分之一宽度。
local function split_three_columns(pane, project_dir)
	local left_and_middle = pane:split({
		direction = "Left",
		size = 2 / 3,
		cwd = project_dir,
	})
	local left = left_and_middle:split({
		direction = "Left",
		size = 0.5,
		cwd = project_dir,
	})

	return left, left_and_middle, pane
end

-- 按固定的常用工作区形态拆分窗格，保持所有窗格工作目录一致。
local function split_startup_panes(pane, pane_cnt, project_dir)
	if pane_cnt <= 1 then
		return
	end

	if pane_cnt == 2 then
		split_two_columns(pane, project_dir)
		return
	end

	if pane_cnt == 3 then
		local left = split_two_columns(pane, project_dir)
		split_column_vertically(left, project_dir)
		return
	end

	if pane_cnt == 4 then
		local left, right = split_two_columns(pane, project_dir)
		split_column_vertically(left, project_dir)
		split_column_vertically(right, project_dir)
		return
	end

	if pane_cnt == 5 then
		local left, middle = split_three_columns(pane, project_dir)
		split_column_vertically(left, project_dir)
		split_column_vertically(middle, project_dir)
		return
	end

	if pane_cnt == 6 then
		local left, middle, right = split_three_columns(pane, project_dir)
		split_column_vertically(left, project_dir)
		split_column_vertically(middle, project_dir)
		split_column_vertically(right, project_dir)
		return
	end

	local left, middle, right = split_three_columns(pane, project_dir)
	split_column_vertically(left, project_dir)
	split_column_vertically(middle, project_dir)
	split_column_vertically(right, project_dir)
end

-- 延后最大化新建窗口，并在窗口尺寸稳定后继续执行布局拆分。
local function maximize_window_later(window, after_maximize)
	wezterm.time.call_after(1, function()
		local gui = window:gui_window()
		if gui then
			gui:maximize()
		end

		if after_maximize then
			wezterm.time.call_after(0.1, after_maximize)
		end
	end)
end

--- 按指定 pane 数量打开一个新窗口，并应用对应固定布局。
M.spawn_pane_layout = function(pane_cnt, project_dir, args)
	local tab, pane, window = mux.spawn_window({
		workspace = "coding",
		cwd = project_dir or wezterm.home_dir,
		args = args or {},
	})
	tab:set_title("coding")

	mux.set_active_workspace("coding")
	maximize_window_later(window, function()
		split_startup_panes(pane, math.max(math.floor(tonumber(pane_cnt) or 1), 1), project_dir or wezterm.home_dir)
	end)
end

-- 向现有快捷键列表追加 workspace 快捷键，避免覆盖 keymap.lua 的配置。
local function append_layout_keys(config)
	config.keys = config.keys or {}
	local layout_keys = {
		-- 切换到默认 coding workspace。
		{
			key = "a",
			mods = "CTRL|SHIFT",
			action = act.SwitchToWorkspace({
				name = "coding",
			}),
		},
		-- 切换到 monitoring workspace，并自动启动 top。
		{
			key = "t",
			mods = "CTRL|SHIFT",
			action = act.SwitchToWorkspace({
				name = "monitoring",
				spawn = {
					args = { "top" },
				},
			}),
		},
		-- 创建一个随机名称的 workspace 并切换过去。
		{ key = "n", mods = "CTRL|SHIFT", action = act.SwitchToWorkspace },
		-- 打开 workspace fuzzy launcher，便于快速切换。
		{
			key = "9",
			mods = "CTRL|SHIFT",
			action = act.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
	}

	for _, binding in ipairs(layout_keys) do
		table.insert(config.keys, binding)
	end
end

wezterm.on("gui-startup", function(cmd)
	local project_dir, args, pane_cnt = parse_startup_args(cmd)
	wezterm.log_info("startup project", project_dir, "panes", pane_cnt)
	M.spawn_pane_layout(pane_cnt, project_dir, args)
end)

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

--- 配置 workspace 相关快捷键。
M.config = function(config)
	append_layout_keys(config)
end

return M
