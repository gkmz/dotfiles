local ok, err = xpcall(function()
  local terminal = require("utils.terminal")
  terminal.toggle("right", 1)
  vim.wait(100)
  local right_win = vim.api.nvim_get_current_win()
  local right_height = vim.api.nvim_win_get_height(right_win)
  terminal.toggle("bottom", 1)
  vim.wait(100)
  terminal.toggle("bottom", 2)
  vim.wait(100)
  assert(vim.api.nvim_win_is_valid(right_win), "Right terminal window was lost")
  assert(vim.api.nvim_win_get_height(right_win) == right_height, "Right terminal height changed")
  local right_col = vim.api.nvim_win_get_position(right_win)[2]
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= right_win and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
      assert(vim.api.nvim_win_get_position(win)[2] < right_col, "Bottom terminal escaped into right column")
    end
  end
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end

print("OK: terminal layout keeps right column stable")
vim.cmd("qa!")
