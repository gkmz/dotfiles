local M = {}

-- 按布局区域保存终端状态，避免同一个编号在不同方向之间互相复用。
local groups = {
  bottom = { terms = {}, jobs = {}, wins = {}, root_win = nil },
  right = { terms = {}, jobs = {}, wins = {}, root_win = nil },
  float = { terms = {}, jobs = {}, wins = {}, root_win = nil },
}

local defaults = {
  bottom_size = 15,
  right_width_ratio = 0.4,
  float_width_ratio = 0.82,
  float_height_ratio = 0.78,
}

local function valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function valid_job(job)
  return job and vim.fn.jobwait({ job }, 0)[1] == -1
end

local function term_enter()
  -- 打开终端后直接进入输入态，符合终端窗口的常见操作预期。
  vim.cmd("startinsert")
end

local function term_leave()
  if vim.fn.mode() == "t" then
    -- 从终端模式触发快捷键时，先回到 normal 状态再调整窗口布局。
    vim.cmd("stopinsert")
  end
end

local function shell_cmd()
  local shell = vim.env.SHELL or vim.o.shell
  local shell_name = vim.fn.fnamemodify(shell, ":t")

  -- 常见交互 shell 显式加 -i，确保能加载用户的交互式配置和提示符。
  if shell_name == "zsh" or shell_name == "bash" or shell_name == "fish" then
    return { shell, "-i" }
  end

  return shell
end

local function create_terminal_buf(group_name, id)
  local buf = vim.api.nvim_create_buf(false, true)
  local group = groups[group_name]

  vim.api.nvim_buf_set_name(buf, string.format("terminal://%s/%d", group_name, id))
  vim.bo[buf].buflisted = false
  vim.bo[buf].bufhidden = "hide"

  vim.api.nvim_buf_call(buf, function()
    -- 使用 termopen 显式启动真实 shell，避免 :terminal 在手工 buffer 中创建异常空终端。
    group.jobs[id] = vim.fn.termopen(shell_cmd(), {
      cwd = vim.fn.getcwd(),
      on_exit = function()
        group.jobs[id] = nil
      end,
    })
  end)

  return buf
end

local function get_terminal_buf(group_name, id)
  local group = groups[group_name]
  if not valid_buf(group.terms[id]) or not valid_job(group.jobs[id]) then
    if valid_buf(group.terms[id]) then
      vim.api.nvim_buf_delete(group.terms[id], { force = true })
    end

    -- 每个区域独立维护编号，同一个 id 可以同时存在于 bottom/right/float。
    group.terms[id] = create_terminal_buf(group_name, id)
  end
  return group.terms[id]
end

local function open_bottom_window(group, id, buf)
  if id == 1 or not valid_win(group.root_win) then
    vim.cmd("botright split")
    vim.cmd("resize " .. defaults.bottom_size)
    group.root_win = vim.api.nvim_get_current_win()
  else
    -- bottom 区域追加终端时，在底部终端组里继续向右分裂。
    vim.api.nvim_set_current_win(group.root_win)
    vim.cmd("rightbelow vsplit")
  end

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.cmd("resize " .. defaults.bottom_size)
  return win
end

local function open_right_window(group, id, buf)
  if id == 1 or not valid_win(group.root_win) then
    vim.cmd("botright vsplit")
    vim.cmd("vertical resize " .. math.floor(vim.o.columns * defaults.right_width_ratio))
    group.root_win = vim.api.nvim_get_current_win()
  else
    -- right 区域追加终端时，在右侧终端组里继续向下分裂。
    vim.api.nvim_set_current_win(group.root_win)
    vim.cmd("rightbelow split")
  end

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.cmd("vertical resize " .. math.floor(vim.o.columns * defaults.right_width_ratio))
  return win
end

local function open_float_window(buf)
  local width = math.floor(vim.o.columns * defaults.float_width_ratio)
  local height = math.floor(vim.o.lines * defaults.float_height_ratio)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  -- float 终端使用独立浮窗，不参与普通 split 布局。
  return vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    width = width,
    height = height,
    row = math.max(row, 0),
    col = math.max(col, 0),
  })
end

local function open_window(group_name, id, buf)
  local group = groups[group_name]

  if group_name == "bottom" then
    return open_bottom_window(group, id, buf)
  end

  if group_name == "right" then
    return open_right_window(group, id, buf)
  end

  return open_float_window(buf)
end

--- 切换指定区域的终端。
--- @param group_name "bottom"|"right"|"float" 终端布局区域。
--- @param id? integer 终端编号；未传时默认使用 1。
function M.toggle(group_name, id)
  term_leave()

  group_name = group_name or "bottom"
  id = id or 1

  local group = groups[group_name]
  if not group then
    error("Unknown terminal group: " .. tostring(group_name))
  end

  local win = group.wins[id]
  if valid_win(win) then
    -- 当前就在目标终端时隐藏窗口，否则跳转过去。
    if vim.api.nvim_get_current_win() == win then
      vim.api.nvim_win_hide(win)
      return
    end

    vim.api.nvim_set_current_win(win)
    term_enter()
    return
  end

  local buf = get_terminal_buf(group_name, id)
  group.wins[id] = open_window(group_name, id, buf)
  term_enter()
end

--- 隐藏所有由本模块管理的终端窗口，但保留终端 buffer 和 shell 进程。
function M.hide_all_terminals()
  term_leave()

  for _, group in pairs(groups) do
    for id, win in pairs(group.wins) do
      if valid_win(win) then
        vim.api.nvim_win_hide(win)
      end

      group.wins[id] = nil
    end

    group.root_win = nil
  end
end

--- 关闭所有由本模块管理的终端 buffer 和窗口。
function M.close_all_terminals()
  for _, group in pairs(groups) do
    for _, win in pairs(group.wins) do
      if valid_win(win) then
        vim.api.nvim_win_close(win, true)
      end
    end

    for _, buf in pairs(group.terms) do
      if valid_buf(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end

    group.terms = {}
    group.jobs = {}
    group.wins = {}
    group.root_win = nil
  end

  vim.g.terminal_buf = nil
  vim.g.terminal_win = nil
end

--- 使用 Snacks 的终端切换能力。
function M.toggle_fterm()
  Snacks.terminal.toggle()
end

--- 兼容旧调用：切换底部 1 号终端。
function M.toggle_terminal_native()
  M.toggle("bottom", 1)
end

--- 兼容旧调用：在底部区域创建或切换下一个右侧终端。
function M.split_terminal_right()
  local next_id = #groups.bottom.terms + 1
  M.toggle("bottom", math.max(next_id, 2))
end

return M
