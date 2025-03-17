local function find_executable(executable_name)
  local paths = {
    vim.fn.expand(".venv/bin/" .. executable_name), -- 项目级
    vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/" .. executable_name), -- VIRTUAL_ENV
    vim.fn.expand("~/.venvs/python3/bin/" .. executable_name), -- 全局虚拟环境
    vim.fn.expand("~/.local/share/nvim/mason/bin/" .. executable_name),
    vim.fn.exepath(executable_name), -- 系统全局
  }
  for _, path in ipairs(paths) do
    if path and vim.fn.executable(path) == 1 then
      return path
    end
  end
  return nil
end

local function notify_tooling(lang)
  local ok, notifications = pcall(require, "utils.defaults")
  if not ok or not notifications[lang] then
    vim.notify("Notifications config not found", vim.log.levels.ERROR)
    return
  end
  local infos = ""
  local warnings = ""
  local errors = ""
  for tool, info in pairs(notifications) do
    if type(info) == "table" then
      if info.path ~= nil then
        if info.warn == true then
          warnings = warnings
            .. "Using "
            .. tool
            .. " from Mason ("
            .. info.path
            .. "), consider installing it in your virtual environment.\n"
        else
          infos = infos .. "Using " .. tool .. ": " .. info.path .. "\n"
        end
      else
        errors = errors .. tool .. " not found.\n"
      end
    end
  end

  -- remove newline from end of strings
  infos = string.sub(infos, 1, -2)
  warnings = string.sub(warnings, 1, -2)
  errors = string.sub(errors, 1, -2)

  if infos ~= "" then
    vim.notify_once(infos, vim.log.levels.INFO)
  end
  if warnings ~= "" then
    vim.notify_once(warnings, vim.log.levels.WARN)
  end
  if errors ~= "" then
    vim.notify_once(errors, vim.log.levels.ERROR)
  end
end

-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   pattern = { "*.py" },
--   callback = function(args)
--     -- 避免重复执行
--     -- if vim.b[args.buf].python_setup then
--     --   return
--     -- end
--
--     local notifications = require("utils.defaults").notifications.python
--
--     -- 设置缓冲区选项
--     vim.opt_local.tabstop = 4
--     vim.opt_local.shiftwidth = 4
--     vim.opt_local.colorcolumn = "100"
--
--     -- 设置 Python 解释器
--     if not vim.g.python3_host_prog then
--       notifications.python3.path = find_executable("python")
--       vim.g.python3_host_prog = notifications.python3.path
--     end
--
--     -- 通知只触发一次
--     if not notifications._emitted then
--       notify_tooling("python")
--       notifications._emitted = true
--     end
--
--     vim.b[args.buf].python_setup = true
--   end,
-- })

return {
  -- {
  --   "neovim/nvim-lspconfig",
  --   ft = { "python" },
  --   opts = {
  --     servers = {
  --       ruff = {
  --         cmd_env = { RUFF_TRACE = "messages" },
  --         init_options = {
  --           settings = {
  --             logLevel = "error",
  --           },
  --         },
  --         keys = {
  --           {
  --             "<leader>co",
  --             LazyVim.lsp.action["source.organizeImports"],
  --             desc = "Organize Imports",
  --           },
  --         },
  --       },
  --       ruff_lsp = {
  --         keys = {
  --           {
  --             "<leader>co",
  --             LazyVim.lsp.action["source.organizeImports"],
  --             desc = "Organize Imports",
  --           },
  --         },
  --       },
  --     },
  --     setup = {
  --       [ruff] = function()
  --         LazyVim.lsp.on_attach(function(client, _)
  --           -- Disable hover in favor of Pyright
  --           client.server_capabilities.hoverProvider = false
  --         end, ruff)
  --       end,
  --     },
  --   },
  -- },

  {
    "nvim-neotest/neotest",
    ft = { "python" },
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          args = { "--log-level", "DEBUG", "--color", "yes", "-vv", "-s" },
          dap = { justMyCode = false },
          python = find_executable("python"),
          -- Returns if a given file path is a test file.
          -- NB: This function is called a lot so don't perform any heavy tasks within it.
          is_test_file = function(file_path)
            return vim.fs.basename(file_path):match("test_") or vim.fs.basename(file_path):match("_test")
          end,
          -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
          -- instances for files containing a parametrize mark (default: false)
          pytest_discover_instances = false,
        },
      },
    },
  },

  {
    "andythigpen/nvim-coverage",
    ft = { "python" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      auto_reload = true,
      lang = {
        python = {
          coverage_file = vim.fn.getcwd() .. "/coverage.out",
        },
      },
    },
  },

  -- poetry-nvim plugin using when using poetry
  {
    "karloskar/poetry-nvim",
    ft = { "python" },
    config = function()
      require("poetry-nvim").setup()
    end,
  },
}
