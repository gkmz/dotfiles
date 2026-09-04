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

  local navigation = require("utils.treesitter_navigation")
  vim.api.nvim_win_set_cursor(0, { 3, 0 })
  local function_name = navigation.current_function_name_position()
  assert(function_name and function_name[1] == 3 and function_name[2] == 5, "failed to locate the Go function name from line start")
  vim.api.nvim_win_set_cursor(0, { 4, 1 })
  function_name = navigation.current_function_name_position()
  assert(function_name and function_name[1] == 3 and function_name[2] == 5, "failed to locate the Go function name from the function body")

  local next_method_name = vim.fn.maparg("]]", "n", false, true)
  local previous_method_name = vim.fn.maparg("[[", "n", false, true)
  assert(next_method_name.desc ~= "Next Function Name", "]] should not be a custom function-name mapping")
  assert(previous_method_name.desc ~= "Previous Function Name", "[[ should not be a custom function-name mapping")

  vim.api.nvim_exec_autocmds("LspAttach", { buffer = 0, modeline = false, data = { client_id = 0 } })
  vim.wait(100, function()
    return vim.fn.maparg("gr", "n", false, true).buffer == 1
  end)
  local references = vim.fn.maparg("gr", "n", false, true)
  assert(references.buffer == 1, "gr is not a buffer-local LSP mapping")
  assert(type(references.callback) == "function", "gr does not have a Lua callback")

  local requested_position
  local original_request_all = vim.lsp.buf_request_all
  vim.lsp.buf_request_all = function(_, method, params)
    assert(method == "textDocument/references", "gr did not send a references request")
    requested_position = params.position
    return {}
  end
  vim.api.nvim_win_set_cursor(0, { 3, 0 })
  references.callback()
  vim.wait(100)
  vim.lsp.buf_request_all = original_request_all
  assert(requested_position and requested_position.line == 2 and requested_position.character == 5, "references request did not use the Go function name position")
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end
print("OK: function navigation resolves names for gr")
vim.cmd("qa!")
