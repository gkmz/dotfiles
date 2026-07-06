local M = {}

local state = {
  win = nil,
  buf = nil,
}

local file_commands = {
  go = function(file)
    return { "go", "run", file }
  end,
  python = function(file)
    return { "python3", "-u", file }
  end,
  javascript = function(file)
    return { "node", file }
  end,
  typescript = function(file)
    return { "deno", "run", file }
  end,
  sh = function(file)
    return { "bash", file }
  end,
}

local function shell_join(argv)
  return table.concat(
    vim.tbl_map(function(part)
      return vim.fn.shellescape(part)
    end, argv),
    " "
  )
end

local function find_root(markers)
  local start = vim.fn.expand("%:p:h")
  local found = vim.fs.find(markers, { upward = true, path = start })[1]
  return found and vim.fs.dirname(found) or vim.fn.getcwd()
end

local function open_terminal(argv, cwd)
  if vim.bo.modified then
    vim.cmd("write")
  end

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  vim.cmd("botright 15split")
  state.win = vim.api.nvim_get_current_win()
  vim.cmd("terminal cd " .. vim.fn.shellescape(cwd) .. " && " .. shell_join(argv))
  state.buf = vim.api.nvim_get_current_buf()
  vim.cmd("startinsert")
end

---运行当前文件。
function M.run_file()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return
  end

  local builder = file_commands[vim.bo.filetype]
  if not builder then
    vim.notify("No runner configured for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end

  open_terminal(builder(file), vim.fn.expand("%:p:h"))
end

---运行当前项目的默认入口。
function M.run_project()
  local root = find_root({ "go.mod", "Makefile", "package.json" })

  if vim.fn.filereadable(root .. "/Makefile") == 1 then
    open_terminal({ "make", "run" }, root)
    return
  end

  if vim.fn.filereadable(root .. "/go.mod") == 1 then
    open_terminal({ "go", "run", "." }, root)
    return
  end

  if vim.fn.filereadable(root .. "/package.json") == 1 then
    open_terminal({ "npm", "run", "dev" }, root)
    return
  end

  vim.notify("No project runner found. Expected Makefile, go.mod, or package.json.", vim.log.levels.WARN)
end

---关闭最近一次运行窗口。
function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
    return
  end

  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
    state.buf = nil
  end
end

return M
