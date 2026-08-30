local ok, err = xpcall(function()
  -- Headless 测试不会触发 LazyVim 的 VeryLazy 自动加载，显式加载项目 autocmd 配置。
  dofile(vim.fn.stdpath("config") .. "/lua/config/autocmds.lua")
  vim.cmd("botright split")
  vim.cmd("terminal")
  vim.wait(100)

  assert(vim.bo.buftype == "terminal", "Test buffer is not a terminal")
  assert(vim.wo.wrap == false, "Terminal window must not soft-wrap terminal output")
  assert(vim.wo.linebreak == false, "Terminal window must not use linebreak wrapping")
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end

print("OK: terminal display options are stable")
vim.cmd("qa!")
