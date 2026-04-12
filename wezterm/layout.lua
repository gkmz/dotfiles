local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local M = {}

wezterm.on("gui-startup", function(cmd)
	-- 注意：gui-startup 在 gui-attached 之前触发，不能对「刚 spawn 的 mux 窗口」立刻 gui_window()，
	-- 否则会报错：mux window id N is not currently associated with a gui window。
	-- 也不要在这里额外 spawn 一个空窗口再 maximize——会多出一个无意义的 window id=1 并更容易踩中上述时序问题。

	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local project_dir = wezterm.home_dir
	local args = {}
	local paneCnt = 1
	if cmd then
		if #cmd.args >= 1 then
			if cmd.args[1]:match("%d") then
				paneCnt = math.floor(tonumber(cmd.args[1]))
			else
				project_dir = cmd.args[1]
			end
		end
		if #cmd.args == 2 then
			paneCnt = math.floor(tonumber(cmd.args[2]))
		end
	end

	print(project_dir, paneCnt)

	-- Set a workspace for coding on a current project
	local tab, pane, window = mux.spawn_window({
		workspace = "coding",
		cwd = project_dir,
		args = args,
	})
	tab:set_title("coding")
	-- 延后到下一帧再取 gui_window，避免 mux 尚未挂到 GUI
	wezterm.time.call_after(1, function()
		local gui = window:gui_window()
		if gui then
			gui:maximize()
		end
	end)

	if paneCnt > 1 then
		if paneCnt > 3 then
			local col = math.floor(paneCnt / 2)
			if paneCnt % 2 > 0 then
				col = col + 1
			end
			repeat
				local subPane = pane:split({
					direction = "Left",
					size = 7 / col,
					cwd = project_dir,
				})
				subPane:split({
					direction = "Top",
					size = 0.5,
					cwd = project_dir,
				})
				paneCnt = paneCnt - 2
			until paneCnt <= 2
			if paneCnt == 2 then
				pane:split({
					direction = "Top",
					size = 0.5,
					cwd = project_dir,
				})
			end
		else
			for _ = 1, paneCnt - 1, 1 do
				pane:split({
					direction = "Left",
					size = 1 / paneCnt,
					cwd = project_dir,
				})
			end
		end
	end

	mux.set_active_workspace("coding")
end)

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

M.config = function(config)
	config.keys = {
		-- Switch to the default workspace
		{
			key = "a",
			mods = "CTRL|SHIFT",
			action = act.SwitchToWorkspace({
				name = "coding",
			}),
		},
		-- Switch to a monitoring workspace, which will have `top` launched into it
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
		-- Create a new workspace with a random name and switch to it
		{ key = "n", mods = "CTRL|SHIFT", action = act.SwitchToWorkspace },
		-- Show the launcher in fuzzy selection mode and have it list all workspaces
		-- and allow activating one.
		{
			key = "9",
			mods = "CTRL|SHIFT",
			action = act.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
	}
end

return M
