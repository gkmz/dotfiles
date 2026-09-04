local ok, err = xpcall(function()
  -- 加载真实插件配置，验证方法跳转不是回退到 Vim 内置的文件名跳转。
  require("lazy").load({ plugins = { "nvim-treesitter", "nvim-treesitter-textobjects" } })
  require("config.keymaps")

  local treesitter = require("nvim-treesitter")
  assert(vim.list_contains(treesitter.get_installed("parsers"), "go"), "Go Treesitter parser is not installed")

  local lines = {
    "package navigation",
    "",
    "func first() {",
    "}",
    "",
    "func second() {",
    "}",
  }

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.filetype = "go"

  local next_function = vim.fn.maparg("]f", "n", false, true)
  assert(next_function.buffer == 1, "]f is not a buffer-local Treesitter mapping")
  assert(type(next_function.callback) == "function", "]f does not have a Lua callback")

  vim.api.nvim_win_set_cursor(0, { 3, 0 })
  next_function.callback()
  assert(vim.api.nvim_win_get_cursor(0)[1] == 6, "]f did not jump to the next Go function")

  local previous_function = vim.fn.maparg("[f", "n", false, true)
  assert(previous_function.buffer == 1, "[f is not a buffer-local Treesitter mapping")
  assert(type(previous_function.callback) == "function", "[f does not have a Lua callback")

  previous_function.callback()
  assert(vim.api.nvim_win_get_cursor(0)[1] == 3, "[f did not jump to the previous Go function")

  local previous_name = vim.fn.maparg("[M", "n", false, true)
  local next_name = vim.fn.maparg("]M", "n", false, true)
  assert(type(previous_name.callback) == "function", "[M does not have a Lua callback")
  assert(type(next_name.callback) == "function", "]M does not have a Lua callback")

  vim.api.nvim_win_set_cursor(0, { 3, 0 })
  next_name.callback()
  local next_name_position = vim.api.nvim_win_get_cursor(0)
  assert(next_name_position[1] == 6 and next_name_position[2] == 5, "]M did not jump to the next Go function name")

  previous_name.callback()
  local previous_name_position = vim.api.nvim_win_get_cursor(0)
  assert(previous_name_position[1] == 3 and previous_name_position[2] == 5, "[M did not jump to the previous Go function name")

end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end
print("OK: function text objects and name navigation jump between Go functions")
vim.cmd("qa!")
