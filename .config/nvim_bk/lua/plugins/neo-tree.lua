local remove_lsp_cwd = require("utils/util").remove_lsp_cwd

local function is_file(path)
  if path:sub(-1) == "/" then
    return false
  else
    return true
  end
end

local function get_filetype_from_path(path)
  local match = string.match(path, "%.([^%.\\/]*)$")
  if match then
    local ext = string.lower(match)
    if ext == "go" then
      return "go"
    elseif ext == "ts" then
      return "typescript"
    elseif ext == "py" then
      return "python"
    elseif ext == "lua" then
      return "lua"
    elseif ext == "vue" then
      return "vuejs"
    elseif ext == "rs" then
      return "rust"
    elseif ext == "java" then
      return "java"
    else
      return "unknown"
    end
  else
    return "unknown"
  end
end

local function get_parent_dir(path)
  if not path then
    return nil
  end

  local parent_path = path:match("(.+)/")
  if parent_path then
    local name = parent_path:match("([^/]+)$")
    return name
  else
    return "root"
  end
end

local function get_filename_without_extension_from_path(path, client_name)
  local relative_path = remove_lsp_cwd(path, client_name)
  if relative_path == nil then
    return nil
  end
  return get_parent_dir(relative_path)
end

local go_file = function(path)
  local file = io.open(path, "w")
  if file then
    local parent_name = get_filename_without_extension_from_path(path, "gopls")
    if parent_name ~= nil then
      if parent_name == "root" then
        parent_name = "main"
      end
      file:write("package " .. parent_name .. "\n")
    end
    file:close()
  end
end
local rust_file = function(path) end
local python_file = function(path) end
local vuejs_file = function(path) end
local java_file = function(path) end
local lua_file = function(path) end
local unknown_file = function(path) end

local filetype_mapping = {
  go = go_file,
  rust = rust_file,
  python = python_file,
  vuejs = vuejs_file,
  java = java_file,
  lua = lua_file,
  unknown = unknown_file,
}

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
      {
        "s1n7ax/nvim-window-picker",
        -- version = "2.*",
        config = function()
          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
          })
        end,
      },
    },
    opts = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
          desc = "Copy Path to Clipboard",
        },
        ["O"] = {
          function(state)
            require("lazy.util").open(state.tree:get_node().path, { system = true })
          end,
          desc = "Open with System Application",
        },
        ["P"] = { "toggle_preview", config = { use_float = false } },
      },
    },
  },
}
