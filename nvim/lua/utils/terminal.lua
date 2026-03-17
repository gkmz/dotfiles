M = {}

function M.toggle_terminal_native()
  -- If the terminal buffer doesn't exist or is no longer valid...
  if not vim.g.terminal_buf or not vim.api.nvim_buf_is_valid(vim.g.terminal_buf) then
    -- Create a new terminal buffer
    vim.g.terminal_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(vim.g.terminal_buf, "buftype", "nofile") -- FIXME: deprecated
    vim.api.nvim_buf_call(vim.g.terminal_buf, function()
      vim.cmd("terminal")
    end)
  end
  -- If the terminal window doesn't exist or is no longer valid...
  if not vim.g.terminal_win or not vim.api.nvim_win_is_valid(vim.g.terminal_win) then
    -- Create a new split window and display the terminal buffer in it
    vim.cmd("split")
    vim.g.terminal_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(vim.g.terminal_win, vim.g.terminal_buf)
  else
    -- If the terminal window is the current window, hide it
    if vim.api.nvim_get_current_win() == vim.g.terminal_win then
      vim.api.nvim_win_hide(vim.g.terminal_win)
    else -- Otherwise, switch to the terminal window
      vim.api.nvim_set_current_win(vim.g.terminal_win)
    end
  end
end

function M.toggle_fterm()
  Snacks.terminal.toggle()
end

function M.toggle_toggleterm()
  -- NOTE: this requires toggleterm
  local cwd = vim.fn.getcwd()
  local cwd_folder_name = vim.fn.fnamemodify(cwd, ":t")

  local cmd = ":ToggleTerm size=40 dir=" .. cwd .. " direction=horizontal name=" .. cwd_folder_name
  vim.cmd(cmd)
end

function M.split_terminal_right()
  -- 只有在当前已经在终端窗口中时，才进行右侧分屏
  if vim.bo.buftype ~= "terminal" then
    M.toggle_terminal_native()
    return
  end

  -- 在右侧打开垂直分屏
  vim.cmd("vsplit")
  vim.cmd("terminal")
  -- 自动进入插入模式
  vim.cmd("startinsert")
end

function M.close_all_terminals()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      -- 强制删除终端 buffer，对应的窗口也会关闭
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.g.terminal_buf = nil
  vim.g.terminal_win = nil
end
return M

