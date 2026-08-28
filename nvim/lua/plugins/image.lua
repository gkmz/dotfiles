return {
  {
    "3rd/image.nvim",
    -- 使用 ImageMagick 命令行处理图片，避免额外编译 Lua rock。
    build = false,
    opts = {
      -- WezTerm 支持 Kitty Graphics Protocol，优先使用性能更好的原生后端。
      backend = "kitty",
      processor = "magick_cli",

      -- 打开图片文件时直接由 image.nvim 接管当前 buffer。
      hijack_file_patterns = {
        "*.png",
        "*.jpg",
        "*.jpeg",
        "*.gif",
        "*.webp",
        "*.avif",
      },

      -- 大图最多占窗口高度的 80%，避免图片完全遮住编辑区域。
      max_height_window_percentage = 80,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true,
    },
  },
}
