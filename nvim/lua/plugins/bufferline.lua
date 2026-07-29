return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      local colors = require("tokyonight.colors").setup()

      opts.options = opts.options or {}
      opts.options.indicator = vim.tbl_deep_extend("force", opts.options.indicator or {}, {
        style = "none",
      })

      -- 激活项使用更醒目的连续背景，不使用会遮挡文字底部的下划线。
      local selected_highlights = {}
      for _, group in ipairs({
        "tab_selected",
        "tab_separator_selected",
        "buffer_selected",
        "close_button_selected",
        "numbers_selected",
        "diagnostic_selected",
        "hint_selected",
        "hint_diagnostic_selected",
        "info_selected",
        "info_diagnostic_selected",
        "warning_selected",
        "warning_diagnostic_selected",
        "error_selected",
        "error_diagnostic_selected",
        "modified_selected",
        "duplicate_selected",
        "separator_selected",
        "indicator_selected",
        "pick_selected",
      }) do
        selected_highlights[group] = {
          bg = colors.bg_visual,
          default = false,
          underline = false,
        }
      end

      selected_highlights.buffer_selected = vim.tbl_extend("force", selected_highlights.buffer_selected, {
        fg = colors.fg,
        bold = true,
        italic = false,
      })
      selected_highlights.close_button_selected.fg = colors.fg

      opts.highlights = vim.tbl_deep_extend("force", opts.highlights or {}, selected_highlights)
    end,
  },
}
