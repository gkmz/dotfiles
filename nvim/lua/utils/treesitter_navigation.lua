local M = {}

-- 返回当前光标所在函数节点及其名称节点。
local function current_function_nodes(bufnr)
  local filetype = vim.bo[bufnr].filetype
  if filetype == "" then
    return nil, nil
  end
  local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr, filetype)
  local query = vim.treesitter.query.get(filetype, "textobjects")
  if not parser_ok or not parser or not query then
    return nil, nil
  end
  local tree = parser:parse()[1]
  if not tree then
    return nil, nil
  end
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, column = cursor[1] - 1, cursor[2]
  local best_node, best_name
  for capture_id, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
    if query.captures[capture_id] == "function.outer" then
      local start_row, start_col, end_row, end_col = node:range()
      local inside = row > start_row and row < end_row
        or (row == start_row and column >= start_col)
        or (row == end_row and column < end_col)
      local name = node:field("name")[1]
      if inside and name and (not best_node or node:byte_length() < best_node:byte_length()) then
        best_node, best_name = node, name
      end
    end
  end
  return best_node, best_name
end

--- 获取当前函数名的位置，返回 `{ 行号, 列号 }`（行号从 1 开始，列号从 0 开始）。
function M.current_function_name_position()
  local _, name = current_function_nodes(vim.api.nvim_get_current_buf())
  if not name then
    return nil
  end
  local row, column = name:start()
  return { row + 1, column }
end

--- 将光标临时定位到当前函数名，供 LSP 引用查询使用。
function M.prepare_reference_lookup()
  local position = M.current_function_name_position()
  if position then
    vim.api.nvim_win_set_cursor(0, position)
  end
end

--- 直接以函数名称节点的位置发起 LSP 引用请求，避免异步 picker 重新读取行首位置。
function M.request_references()
  local bufnr = vim.api.nvim_get_current_buf()
  local position = M.current_function_name_position()
  local params = vim.lsp.util.make_position_params(0)
  if position then
    params.position = { line = position[1] - 1, character = position[2] }
  end

  vim.lsp.buf_request_all(bufnr, "textDocument/references", params, function(results)
    local items = {}
    for _, response in pairs(results or {}) do
      for _, location in ipairs(response.result or {}) do
        local item = vim.lsp.util.locations_to_items({ location })[1]
        if item then
          items[#items + 1] = item
        end
      end
    end
    if #items == 0 then
      vim.notify("No references found", vim.log.levels.INFO)
      return
    end
    vim.fn.setqflist({}, " ", { title = "LSP References", items = items })
    vim.cmd("copen")
  end)
end

return M
