local ok, err = xpcall(function()
  vim.cmd.colorscheme("tokyonight-storm")

  local win_separator = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
  local vert_split = vim.api.nvim_get_hl(0, { name = "VertSplit", link = false })
  assert(win_separator.fg ~= nil, "WinSeparator foreground is missing")
  assert(win_separator.fg == vert_split.fg, "Split highlight colors are inconsistent")

  local fillchars = vim.opt.fillchars:get()
  assert(fillchars.vert == "│", "Vertical split character is not configured")
  assert(fillchars.horiz == "─", "Horizontal split character is not configured")
  assert(fillchars.verthoriz == "┼", "Split intersection character is not configured")
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end

print("OK: window separators are visually configured")
vim.cmd("qa!")
