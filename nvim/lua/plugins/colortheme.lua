return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    vscode = true,
    opts = {
      style = "moon",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        colors.comment = colors.fg_dark
      end,
      on_highlights = function(highlights, colors)
        -- 使用中等对比蓝灰色区分 split 窗口，同时避免分隔线抢夺代码焦点。
        highlights.WinSeparator = { fg = colors.blue0 }
        highlights.VertSplit = { fg = colors.blue0 }
      end,
    },
  },
  { "ellisonleao/gruvbox.nvim" },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "tokyonight-night",
      colorscheme = "tokyonight-storm",
      -- colorscheme = "gruvbox",
      -- colorscheme = "catppuccin",
    },
  },
}
