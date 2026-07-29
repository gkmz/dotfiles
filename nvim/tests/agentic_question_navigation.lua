local ok, err = xpcall(function()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
    "##  User - 2026-07-30 09:00:00",
    "第一个问题",
    "### Agent - codex-acp",
    "## 回复中的普通标题",
    "回答内容",
    "##  User - 2026-07-30 09:05:00",
    "第二个问题",
    "### Agent - codex-acp",
    "## User-facing behavior",
    "回答内容",
  })
  vim.bo[bufnr].filetype = "AgenticChat"

  local function find_mapping(lhs)
    for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(bufnr, "n")) do
      if mapping.lhs == lhs then
        return mapping
      end
    end
  end

  local prev_question = assert(find_mapping("[u"), "Agentic previous-question keymap is missing")
  local next_question = assert(find_mapping("]u"), "Agentic next-question keymap is missing")
  assert(type(prev_question.callback) == "function", "Agentic previous-question keymap has no callback")
  assert(type(next_question.callback) == "function", "Agentic next-question keymap has no callback")

  -- 从回复末尾向前时，只落到最近一条用户问题，跳过回复自身的 Markdown 标题。
  vim.api.nvim_win_set_cursor(0, { 10, 0 })
  prev_question.callback()
  assert(vim.api.nvim_win_get_cursor(0)[1] == 6, "Previous question did not skip response headings")
  prev_question.callback()
  assert(vim.api.nvim_win_get_cursor(0)[1] == 1, "Previous question did not reach the first user message")

  -- 向后查找不循环，向前则能回到下一条用户问题。
  prev_question.callback()
  assert(vim.api.nvim_win_get_cursor(0)[1] == 1, "Previous question unexpectedly wrapped")
  next_question.callback()
  assert(vim.api.nvim_win_get_cursor(0)[1] == 6, "Next question did not reach the following user message")
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end

print("OK: Agentic user-question navigation is valid")
vim.cmd("qa!")
