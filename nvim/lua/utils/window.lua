local M = {}

local maximize_source_tab_var = "dotfiles_maximize_source_tab"

local function get_tab_var(tabpage, name)
  local ok, value = pcall(vim.api.nvim_tabpage_get_var, tabpage, name)
  if ok then
    return value
  end

  return nil
end

local function is_terminal_buffer(bufnr)
  return vim.bo[bufnr].buftype == "terminal"
end

local function enter_terminal_insert_if_needed(bufnr)
  if is_terminal_buffer(bufnr) then
    vim.cmd("startinsert")
  end
end

local function close_tabpage(tabpage)
  local ok, tabnr = pcall(vim.api.nvim_tabpage_get_number, tabpage)
  if ok then
    vim.cmd(tabnr .. "tabclose")
  end
end

--- 切换当前窗口的临时全屏视图。
---
--- 实现方式是把当前 buffer 放到一个新的临时 tab 中显示；再次调用时关闭临时 tab，
--- 回到原 tab，因此不会销毁原来的窗口布局，也不会中断 terminal buffer 中的进程。
function M.toggle_current_window_fullscreen()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local source_tab = get_tab_var(current_tab, maximize_source_tab_var)

  if source_tab then
    local fullscreen_tab = current_tab
    if vim.api.nvim_tabpage_is_valid(source_tab) then
      vim.api.nvim_set_current_tabpage(source_tab)
    end

    if vim.api.nvim_tabpage_is_valid(fullscreen_tab) then
      close_tabpage(fullscreen_tab)
    end
    return
  end

  local source_buf = vim.api.nvim_get_current_buf()

  -- 新 tab 复用当前 buffer，达到全屏当前窗口且保留原布局的效果。
  vim.cmd("tab split")
  vim.api.nvim_tabpage_set_var(vim.api.nvim_get_current_tabpage(), maximize_source_tab_var, current_tab)
  enter_terminal_insert_if_needed(source_buf)
end

return M
