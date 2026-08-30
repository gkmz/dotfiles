local M = {}

-- 返回当前 buffer 中所有带 name 字段的函数名称节点。
local function function_name_nodes(bufnr)
  local filetype = vim.bo[bufnr].filetype
  if filetype == "" then
    return {}
  end

  local parser = vim.treesitter.get_parser(bufnr, filetype)
  if not parser then
    return {}
  end

  local query = vim.treesitter.query.get(filetype, "textobjects")
  if not query then
    return {}
  end

  local tree = parser:parse()[1]
  if not tree then
    return {}
  end

  local root = tree:root()
  local names = {}
  local seen = {}
  for capture_id, node in query:iter_captures(root, bufnr, 0, -1) do
    if query.captures[capture_id] == "function.outer" then
      local name = node:field("name")[1]
      if name then
        local row, column = name:start()
        local start_row, start_column, end_row, end_column = node:range()
        local key = string.format("%d:%d", start_row, start_column)
        if not seen[key] then
          seen[key] = true
          names[#names + 1] = {
            row = row,
            column = column,
            start_row = start_row,
            start_column = start_column,
            end_row = end_row,
            end_column = end_column,
          }
        end
      end
    end
  end

  table.sort(names, function(left, right)
    if left.row == right.row then
      return left.column < right.column
    end
    return left.row < right.row
  end)
  return names
end

-- 跳转到前一个或后一个函数名，并支持 vim.v.count1 重复跳转。
function M.jump_function_name(direction)
  local bufnr = vim.api.nvim_get_current_buf()
  local names = function_name_nodes(bufnr)
  if #names == 0 then
    return
  end

  local count = vim.v.count1
  for _ = 1, count do
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_row = cursor[1] - 1
    local cursor_column = cursor[2]
    local target

    if direction > 0 then
      for _, name in ipairs(names) do
        if name.start_row > cursor_row
          or (name.start_row == cursor_row and name.start_column > cursor_column)
        then
          target = name
          break
        end
      end
    else
      for index = #names, 1, -1 do
        local name = names[index]
        if name.end_row < cursor_row
          or (name.end_row == cursor_row and name.end_column <= cursor_column)
        then
          target = name
          break
        end
      end
    end

    if not target then
      return
    end
    vim.api.nvim_win_set_cursor(0, { target.row + 1, target.column })
  end
end

return M
