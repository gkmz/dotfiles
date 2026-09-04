local M = {}

-- 收集当前文件中带有 name 字段的函数/方法节点，并按源码位置排序。
local function function_names(bufnr)
  local filetype = vim.bo[bufnr].filetype
  if filetype == "" then return {} end
  local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr, filetype)
  local query = vim.treesitter.query.get(filetype, "textobjects")
  if not parser_ok or not parser or not query then return {} end
  local tree = parser:parse()[1]
  if not tree then return {} end
  local names, seen = {}, {}
  for capture_id, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
    if query.captures[capture_id] == "function.outer" then
      local name = node:field("name")[1]
      if name then
        local row, column = name:start()
        local start_row, start_column = node:start()
        local key = string.format("%d:%d", start_row, start_column)
        if not seen[key] then
          seen[key] = true
          names[#names + 1] = { row = row, column = column, start_row = start_row, start_column = start_column }
        end
      end
    end
  end
  table.sort(names, function(a, b) return a.start_row == b.start_row and a.start_column < b.start_column or a.start_row < b.start_row end)
  return names
end

-- 跳转到相邻函数/方法的名称位置；支持 vim.v.count1 连续跳转。
function M.jump_function_name(direction)
  local names = function_names(vim.api.nvim_get_current_buf())
  for _ = 1, vim.v.count1 do
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, column = cursor[1] - 1, cursor[2]
    local target
    if direction > 0 then
      for _, name in ipairs(names) do
        if name.start_row > row or (name.start_row == row and name.start_column > column) then target = name; break end
      end
    else
      for index = #names, 1, -1 do
        local name = names[index]
        if name.row < row or (name.row == row and name.column < column) then target = name; break end
      end
    end
    if not target then return end
    vim.api.nvim_win_set_cursor(0, { target.row + 1, target.column })
  end
end

return M
