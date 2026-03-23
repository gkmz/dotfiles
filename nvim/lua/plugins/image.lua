return {
	{
		"3rd/image.nvim",
		opts = {
			backend = "kitty",
			processor = "magick_cli",
			editor_only_render_when_focused = true,
			window_overlap_clear_enabled = true,
			tmux_show_only_in_active_window = true,
			integrations = {
				markdown = {
					enabled = false,
				},
				neorg = {
					enabled = false,
				},
			},
		},
	},
}
