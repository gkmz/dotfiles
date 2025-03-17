local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local M = {}

wezterm.on("gui-startup", function(cmd)
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
	window:gui_window():maximize()

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
