local act = require("wezterm").action
local M = {}

M.multiple_actions = function(keys)
	local actions = {}
	for key in keys:gmatch(".") do
		table.insert(actions, act.SendKey({ key = key }))
	end
	table.insert(actions, act.SendKey({ key = "\n" }))
	return act.Multiple(actions)
end

M.key_table = function(mods, key, action)
	return {
		mods = mods,
		key = key,
		action = action,
	}
end

M.cmd_key = function(key, action)
	return M.key_table("CMD", key, action)
end

M.cmd_ctrl_key = function(key, action)
	return M.key_table("CTRL | CMD", key, action)
end

M.cmd_alt_key = function(key, action)
	return M.key_table("ALT | CMD", key, action)
end

M.cmd_to_tmux_prefix = function(key, tmux_key)
	return M.cmd_key(
		key,
		act.Multiple({
			act.SendKey({ mods = "CTRL", key = "b" }),
			act.SendKey({ key = tmux_key }),
		})
	)
end

M.cmd_ctrl_to_tmux_prefix = function(key, tmux_key)
	return M.cmd_ctrl_key(
		key,
		act.Multiple({
			act.SendKey({ mods = "CTRL", key = "b" }),
			act.SendKey({ key = tmux_key }),
		})
	)
end

return M
